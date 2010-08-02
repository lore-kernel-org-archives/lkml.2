Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0HBDGs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 23:06:48 -0400
Received: from casper.infradead.org ([85.118.1.10]:52341 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0HBDGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 23:06:47 -0400
Date: Sun, 1 Aug 2010 20:06:55 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        swetland@google.com, peterz@infradead.org, tglx@linutronix.de,
        alan@lxorguk.ukuu.org.uk
Subject: Re: Attempted summary of suspend-blockers LKML thread
Message-ID: <20100801200655.7edcf247@infradead.org>
In-Reply-To: <20100802011006.GS2470@linux.vnet.ibm.com>
References: <20100731175841.GA9367@linux.vnet.ibm.com>
	<20100731215214.2543c07e@infradead.org>
	<20100801054816.GI2470@linux.vnet.ibm.com>
	<20100731230101.7cc1d8c7@infradead.org>
	<20100801191228.GL2470@linux.vnet.ibm.com>
	<20100801154708.19817b75@infradead.org>
	<20100802011006.GS2470@linux.vnet.ibm.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Aug 2010 18:10:06 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
 
> If I understand you correctly, a key point of agreement between you
> and the Android guys is that both the system and the user have some
> say over how applications are treated by the system in terms of how
> seriously the system takes a given application's requests.
> 
> The Android guys also want the user to have some say about what
> applications are permitted to have some control over "I want to go to
> <this magic deep idle state>" requests.  Does that seem reasonable
> to you?

I personally think it's one of those things where... well we can get a
LONG way automatically (by just observing things); asking the users
is very very often just caving in rather than solving the problem.

Asking the user should only be done for things the user
1) Can give an intelligent answer to
and
2) Are something the user WANTS to be involved in.
   (rather than 'stupid thing, why don't just do the right thing'..
   think the Windows Vista security questions)



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
