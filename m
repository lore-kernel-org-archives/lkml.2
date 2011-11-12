Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754846Ab1KLAjK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 19:39:10 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:36571 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1KLAjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 19:39:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Tomas M." <tmezzadra@gmail.com>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
Date: Sat, 12 Nov 2011 01:41:48 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, j-pihet@ti.com,
        khilman@ti.com, arjan@linux.intel.com, len.brown@intel.com,
        Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4EBD46DF.6060507@gmail.com> <201111112226.25265.rjw@sisk.pl> <4EBD9500.8070204@gmail.com>
In-Reply-To: <4EBD9500.8070204@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111120141.48463.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 11, 2011, Tomas M. wrote:
> yes, that helps.

What does "cat /sys/devices/system/cpu/cpuidle/current_driver" show?

Rafael


> On 11/11/2011 06:26 PM, Rafael J. Wysocki wrote:
> > On Friday, November 11, 2011, Tomas M. wrote:
> >> Follow up.
> >>
> >>
> >> reverted this and the following 3 commits from this patch set and the
> >> problem is gone.
> >>
> >> 46bcfad7a819bd17ac4e831b04405152d59784ab
> >> 4202735e8ab6ecfb0381631a0d0b58fefe0bd4e2
> >> b25edc42bfb9602f0503474b2c94701d5536ce60
> >> e978aa7d7d57d04eb5f88a7507c4fb98577def77
> >>
> >> they all seem to be related.
> > Does it help (without reverting the commits) if you put idle=poll into the
> > kernel command line?
> >
> > Rafael
> >
> >
> >> On 11/11/2011 01:01 PM, Tomas M. wrote:
> >>> bisected to e978aa7d7d57d04eb5f88a7507c4fb98577def77
> >>>
> >>> cannot revert the commit cleanly to further test
> >>>
> >>> attaching pm-suspend log.  /proc/cpuinfo and lspci -vvnn just in case.
> >>> If more info is needed, please let me know.
> >>>
> >>> thanks!
> >>> ----
> >>> when trying to suspend... the system locks right before suspending.
> >>> sysrq keys  will not work at this point
> >>>
> >>>
> >>> please include me in the CC since im not subscribed to the list.
> >>>
> >>> i CCed everyone mentioned in the commit. if you were CCed by mystake,
> >>> sorry.
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >> Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >>
> 
> 

