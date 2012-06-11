Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753618Ab2FKDPE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 23:15:04 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:55846 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109Ab2FKDPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 23:15:02 -0400
Date: Mon, 11 Jun 2012 04:14:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 2/3] x86: Remove cmpxchg from i386 NMI nesting code
In-Reply-To: <32f96f44-00a6-4341-a87c-888e0debcebf@email.android.com>
Message-ID: <alpine.LFD.2.00.1206110406530.29081@eddie.linux-mips.org>
References: <20120608135200.371649691@goodmis.org> <20120608135603.699156773@goodmis.org> <4FD223E1.1090707@zytor.com> <1339173716.13377.50.camel@gandalf.stny.rr.com> <4FD23626.4020802@zytor.com> <1339176975.13377.56.camel@gandalf.stny.rr.com>
 <4FD238CD.8000601@zytor.com> <1339177929.13377.66.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1206110120190.29081@eddie.linux-mips.org> <32f96f44-00a6-4341-a87c-888e0debcebf@email.android.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 10 Jun 2012, H. Peter Anvin wrote:

> Just use a VM or a simulator.

 That wasn't completely serious ;) -- however thanks for the hint.  I 
wonder actually if any piece of software would let the code run in a 
"pass-through" mode and record what I/O accesses went past.  I reckon 
DOSEMU used to support that (and running the VGA BIOS) -- but that piece 
did indeed require vm86.  Then the sequence recorded could be replayed 
natively.

 Thanks for the food for thought! :)

  Maciej
