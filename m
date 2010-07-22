Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0GVFfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 01:35:06 -0400
Received: from vms173017pub.verizon.net ([206.46.173.17]:53277 "EHLO
	vms173017pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab0GVFfA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 01:35:00 -0400
Date: Thu, 22 Jul 2010 01:34:53 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: Jeff Garrett <jeff@jgarrett.org>
Cc: Philip Langdale <philipl@overt.org>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
In-reply-to: <20100427124703.GA16706@jgarrett.org>
Message-id: <alpine.LFD.2.00.1007220128560.409@localhost.localdomain>
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

Jeff,

Please attach the output from acpidump for your dell to this bug report:
https://bugzilla.kernel.org/show_bug.cgi?id=15886

I think we know how to cleanly solve the issue to make Philip's Gigabye
happy, and I'd like to know if your Dell is the same situation
or a different one.

Unfortunately, Matthew's HP fails for a different reason than Philip's 
Gigabyete.  (The BIOS asks for it - so we'll have to poke at the chipset
to find out the reason it is setting BM_STS)

thanks,
Len Brown, Intel Open Source Technology Center

