Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab0FGL21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 07:28:27 -0400
Received: from cantor.suse.de ([195.135.220.2]:35847 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754982Ab0FGL20 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 07:28:26 -0400
Message-ID: <4C0CD7D5.3040202@suse.cz>
Date: Mon, 07 Jun 2010 13:28:21 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [kbuild regression, post-rc1] Remote installation over read-only
 NFS broken
References: <201006071110.26245.rjw@sisk.pl>
In-Reply-To: <201006071110.26245.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.6.2010 11:10, Rafael J. Wysocki wrote:
> Hi Michal,
> 
> Unfortunately, your commit 73d1393eb8507ed5fd7f8e696f6b1ecc18035ebe
> (kbuild: Generate modules.builtin in make modules_install) broke my testing
> environment that had always worked before.
> 
> Namely, I build kernels on a central machine and export the build directory
> along with the kernel sources over read-only NFS to test boxes.  Then, on the
> test boxes I run "make modules_install", copy the kernel to /boot, run mkinitrd
> and so on.  Now, after your commit above the "make modules_install" command on
> the test boxes doesn't work any more, because it tries to write to the build
> directory, which is mounted read-only.

I'll have a look, thanks for the report.

Michal
