Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1JQJiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:38:23 -0400
Received: from www.linutronix.de ([62.245.132.108]:53521 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1JQJiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:38:22 -0400
Date: Mon, 17 Oct 2011 11:38:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Arjan van de Ven <arjan@linux.intel.com>, Matthew Garrett <mjg@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
In-Reply-To: <1318837019.6594.29.camel@twins>
Message-ID: <alpine.LFD.2.02.1110171119580.3240@ionos>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>  <1318349729-3108-4-git-send-email-kirill@shutemov.name>  <20111014154348.ae6267aa.akpm@linux-foundation.org>  <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop> 
 <20111017013921.GA30035@tango.0pointer.de>  <20111017032232.GA4816@srcf.ucam.org> <4E9BBB6D.4050004@linux.intel.com> <1318837019.6594.29.camel@twins>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Peter Zijlstra wrote:

> On Sun, 2011-10-16 at 22:21 -0700, Arjan van de Ven wrote:
> > and..it's not like we let the bad guys go free.
> > We actually seriously hurt their behavior while we throttle their timers 
> > here. 
> 
> How are they hurt? The app appears to behave properly (there are no
> repercussions, the app doesn't crash, the developer doesn't get punched
> in the face). This doesn't make the developer improve his app, nor make
> him take greater care for the next app.
> 
> Such behaviour will in fact encourage crap since he seems to be getting
> away with it.

Unfortunately this is a full speed rolling trainwreck already. The
whole app space is made to encourage shitty applications. Android is
designed exactly in that way and it seems that all other desktop folks
have fully adopted that adsurdity.

Back when NOHZ was merged in the kernel, powertop made people fix crap
left and right in not time. Why should we add something which actively
fosters crappy applications today?

Thanks,

	tglx

