Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab0F2MRr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:17:47 -0400
Received: from cantor.suse.de ([195.135.220.2]:47595 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751456Ab0F2MRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:17:45 -0400
Date: Tue, 29 Jun 2010 14:17:43 +0200
From: Michal Marek <mmarek@suse.cz>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
       David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 2/2] Makefile: "make kernelrelease" should show the
 correct full kernel version
Message-ID: <20100629121743.GC13335@sepie.suse.cz>
References: <20100628030507.5187.95903.sendpatchset@localhost.localdomain>
 <20100628030516.5187.49089.sendpatchset@localhost.localdomain>
 <20100629121315.GA13335@sepie.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100629121315.GA13335@sepie.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 02:13:15PM +0200, Michal Marek wrote:
> AFAICS it was broken even before 85a256d. Nevertheless, the patch is
> correct, but conflicts with 0915512 in the kbuild tree.

http://git.kernel.org/?p=linux/kernel/git/mmarek/kbuild-2.6.git;a=commitdiff;h=0915512 . It is also in linux-next.

Michal
