Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab0GVXfI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 19:35:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52144 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001Ab0GVXfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 19:35:06 -0400
Date: Thu, 22 Jul 2010 16:20:14 -0700
From: Greg KH <gregkh@suse.de>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>,
        Lennart Poettering <lennart@poettering.net>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroupfs: create /sys/fs/cgroup to mount cgroupfs on
Message-ID: <20100722232014.GA32759@suse.de>
References: <20100722182638.GA12712@kroah.com>
 <AANLkTinRGBksuWAZhdmvr39FNACU18+kc5ut49VUf=mp@mail.gmail.com>
 <20100722183614.GA5443@suse.de>
 <AANLkTimbcuzH6_bBhYX0U6vqftYgRwE0ZTmcbaRNzXef@mail.gmail.com>
 <20100722185301.GA528@suse.de>
 <AANLkTik07hZot_x0p7xJuY8s4f8pGRd2Mn1+jYfHH2iq@mail.gmail.com>
 <20100722191200.GA5609@suse.de>
 <AANLkTi=8TTeGG3OTbP4zzNAe_rDaNNL8D0Yxp7DixohK@mail.gmail.com>
 <20100722211958.GB1297@suse.de>
 <AANLkTimwUC_ToxADRR9n5_KLFVHgL=ymMngXAyt+OboJ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimwUC_ToxADRR9n5_KLFVHgL=ymMngXAyt+OboJ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 22, 2010 at 04:12:58PM -0700, Paul Menage wrote:
> On Thu, Jul 22, 2010 at 2:19 PM, Greg KH <gregkh@suse.de> wrote:
> >
> > Any suggestions from your side?
> >
> 
> I'd probably go with Matt's suggestion of /var/run.

See Kay's answer for why this will not work.

sorry,

greg k-h
