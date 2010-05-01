Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0EAVhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 17:37:42 -0400
Received: from snt0-omc2-s26.snt0.hotmail.com ([65.55.90.101]:52906 "EHLO
	snt0-omc2-s26.snt0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752902Ab0EAVhl convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 17:37:41 -0400
Message-ID: <SNT125-W34E393FD01CF3CD7BF54DCC3F00@phx.gbl>
X-Originating-IP: [96.253.143.208]
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: <hpa@zytor.com>, <andi@firstfloor.org>
CC: <colin.king@canonical.com>, <mingo@redhat.com>, <tglx@linutronix.de>,
       <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] x86: Disable 4MB page tables for Atom, work around
 errata AAE44
Date: Sat, 1 May 2010 14:37:40 -0700
Importance: Normal
In-Reply-To: <4BC33022.3000608@zytor.com>
References: <1269271251-19775-1-git-send-email-colin.king@canonical.com>
 <87633xayk4.fsf@basil.nowhere.org>,<4BC33022.3000608@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 01 May 2010 21:37:40.0671 (UTC) FILETIME=[86938CF0:01CAE976]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> Much more than that, the constraint is clearly not strict enough. I'm
> currently trying to work out internally what the actual constraint
> should be (it's a bit of a documentation hole at the moment.)
Yea, why does the spec updates say "It is possible for the BIOS to contain a workaround for this erratum." for issues fixed by a microcode update?
Yuhong Bao 		 	   		  
_________________________________________________________________
The New Busy is not the too busy. Combine all your e-mail accounts with Hotmail.
http://www.windowslive.com/campaign/thenewbusy?tile=multiaccount&ocid=PID28326::T:WLMTAGL:ON:WL:en-US:WM_HMP:042010_4