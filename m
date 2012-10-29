Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2J2Hpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 03:45:43 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:42465 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753680Ab2J2Hpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 03:45:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Micael <kam1kaz3@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linux PM list <linux-pm@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Zheng Yan <zheng.z.yan@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Huang Ying <ying.huang@intel.com>
Subject: Re: Power regression found on 3.6-rc1+
Date: Mon, 29 Oct 2012 08:49:38 +0100
Message-ID: <2972912.ooClOChIux@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAKw44fY_f69qGXHbcyXvr4i=or4FpB7TDQVijLkN7tv5iU-zrQ@mail.gmail.com>
References: <CAKw44fY_f69qGXHbcyXvr4i=or4FpB7TDQVijLkN7tv5iU-zrQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 26, 2012 12:37:36 AM Micael wrote:
> I have a laptop running Arch Linux and found that upgrading from 3.5.6
> to 3.6.2 had a huge impact on my battery life. Power consumption went
> from ~10W to ~20W.
> I initially thought it was a i915 driver problem since the CPU temps
> went up and so I opened this bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=49031
> 
> However, as you can see if you read the bug's comments, after
> bisecting this I found the culprit to be commit
> 71a83bd727cc31c5fe960c3758cb396267ff710e:
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=71a83bd727cc31c5fe960c3758cb396267ff710e

I wonder what the problem may be here.

It looks like the polling change in pci_pme_list_scan() is causing problems
to happen.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
