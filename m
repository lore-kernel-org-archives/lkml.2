Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab0JZBGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:06:31 -0400
Received: from vms173013pub.verizon.net ([206.46.173.13]:62990 "EHLO
	vms173013pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab0JZBG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:06:29 -0400
Date: Mon, 25 Oct 2010 21:06:09 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Ingo Molnar <mingo@elte.hu>
Cc: Huang Ying <ying.huang@intel.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>, linux-acpi@vger.kernel.org,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI,
 Generic Hardware Error Source POLL/IRQ/NMI notification type support
In-reply-to: <20101025084553.GA27119@elte.hu>
Message-id: <alpine.LFD.2.00.1010252058370.11036@localhost.localdomain>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
 <1287992610-14996-10-git-send-email-ying.huang@intel.com>
 <20101025084553.GA27119@elte.hu>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  NAKed-by: Ingo Molnar <mingo@elte.hu>

Everybody knows that Linux has a lot to learn about RAS.

I think to catch up, we need to play to Linux's strengths
of continuous improvement.  If we halt patches in this area
then we could wait forever for the "perfect design".

If Linus Torvalds disagrees and wants to NAK this series,
I can live with that.  But it isn't my recommendation.

thanks,
-Len Brown, Intel Open Source Technology Center


