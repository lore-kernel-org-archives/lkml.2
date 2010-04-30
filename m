Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758764Ab0D3Rah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:30:37 -0400
Received: from vms173005pub.verizon.net ([206.46.173.5]:46651 "EHLO
	vms173005pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933106Ab0D3RaB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:30:01 -0400
Date: Fri, 30 Apr 2010 12:25:44 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@sony
To: Jeff Garrett <jeff@jgarrett.org>
Cc: Philip Langdale <philipl@overt.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
In-reply-to: <20100427124703.GA16706@jgarrett.org>
Message-id: <alpine.LFD.2.00.1004301218280.2489@sony>
References: <20100126084740.GA5265@jgarrett.org>
 <87y6jkee1b.fsf@basil.nowhere.org> <20100205160900.GA2736@jgarrett.org>
 <alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
 <20100426194002.586fbaa5@fido5> <20100427124703.GA16706@jgarrett.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Philip, Jeff,
Please open up a bugzilla.kernel.org report and attach the output from 
acpidump from your machines.

I am hopeful that the "right thin to do" is to not look at bm-status
and that perhaps there is a bug where we are looking at it
"by mistake".

However, it is important that the system be operating properly
when it indeed using c6 as it does with that 1 line patch
earlier in this thread.  So if that patch causes abnormal
operation, please let me know.

thanks,
Len Brown, Intel Open Source Technology Center
