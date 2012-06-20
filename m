Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758421Ab2FTWtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:49:35 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53482 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758403Ab2FTWtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:49:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: linux-next: build failure after merge of the pm tree
Date: Thu, 21 Jun 2012 00:54:56 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sameer Nanda <snanda@chromium.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
References: <20120620150140.64b8bd622e00638d3ceed40c@canb.auug.org.au>
In-Reply-To: <20120620150140.64b8bd622e00638d3ceed40c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201206210054.56235.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, June 20, 2012, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/built-in.o:(.toc1+0x37f0): undefined reference to `pm_print_times_enabled'
> 
> Caused by commit 0eb8c06cb620 ("PM / Sleep: Separate printing suspend
> times from initcall_debug") or maybe 1873ce64491a ("M / Sleep: add knob
> for printing device resume times").

That should be fixed now, sorry for the breakage.

Thanks,
Rafael
