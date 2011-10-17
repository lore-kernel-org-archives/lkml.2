Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab1JQHhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 03:37:21 -0400
Received: from merlin.infradead.org ([205.233.59.134]:40792 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580Ab1JQHhT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 03:37:19 -0400
Subject: Re: [PATCH, v10 3/3] cgroups: introduce timer slack controller
From: Peter Zijlstra <peterz@infradead.org>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        containers@lists.linux-foundation.org, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org, Matt Helsley <matthltc@us.ibm.com>,
        linux-api@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
        harald@redhat.com, david@fubar.dk, greg@kroah.com
Date: Mon, 17 Oct 2011 09:36:58 +0200
In-Reply-To: <4E9BBB6D.4050004@linux.intel.com>
References: <1318349729-3108-1-git-send-email-kirill@shutemov.name>
	 <1318349729-3108-4-git-send-email-kirill@shutemov.name>
	 <20111014154348.ae6267aa.akpm@linux-foundation.org>
	 <20111015112006.GA10173@tango.0pointer.de> <1318705910.2664.5.camel@laptop>
	 <20111017013921.GA30035@tango.0pointer.de>
	 <20111017032232.GA4816@srcf.ucam.org> <4E9BBB6D.4050004@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1318837019.6594.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-16 at 22:21 -0700, Arjan van de Ven wrote:
> and..it's not like we let the bad guys go free.
> We actually seriously hurt their behavior while we throttle their timers 
> here. 

How are they hurt? The app appears to behave properly (there are no
repercussions, the app doesn't crash, the developer doesn't get punched
in the face). This doesn't make the developer improve his app, nor make
him take greater care for the next app.

Such behaviour will in fact encourage crap since he seems to be getting
away with it.
