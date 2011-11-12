Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab1KLWLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 17:11:35 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37178 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab1KLWLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 17:11:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ferenc Wagner <wferi@niif.hu>
Subject: Re: [bisected][bug] commit e978aa7d7d57d04eb5f88 breaks suspend on laptop.
Date: Sat, 12 Nov 2011 23:14:14 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: "Tomas M." <tmezzadra@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        deepthi@linux.vnet.ibm.com, g.trinabh@gmail.com, j-pihet@ti.com,
        khilman@ti.com, arjan@linux.intel.com, len.brown@intel.com,
        Arjan van de Ven <arjan@infradead.org>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4EBD46DF.6060507@gmail.com> <201111120250.14151.rjw@sisk.pl> <87k475cxvf.fsf@tac.ki.iif.hu>
In-Reply-To: <87k475cxvf.fsf@tac.ki.iif.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111122314.14530.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, November 12, 2011, Ferenc Wagner wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Saturday, November 12, 2011, Rafael J. Wysocki wrote:
> >> On Friday, November 11, 2011, Tomas M. wrote:
> >>> yes, that helps.
> >> 
> >> What does "cat /sys/devices/system/cpu/cpuidle/current_driver" show?
> >
> > If that's "acpi_idle", the appended patch should help (it works for
> > me at least).
> 
> It works for me, too.

Good, thanks for the confirmation!

Rafael
