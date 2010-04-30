Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0D3QwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:52:23 -0400
Received: from usul.saidi.cx ([204.11.33.34]:60762 "EHLO usul.overt.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757828Ab0D3QwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:52:10 -0400
Date: Fri, 30 Apr 2010 07:57:03 -0700
From: Philip Langdale <philipl@overt.org>
To: jeff@jgarrett.org (Jeff Garrett)
Cc: Len Brown <lenb@kernel.org>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: acpi_idle: Very idle Core i7 machine never enters C3
Message-ID: <20100430075703.15dd05bb@fido5>
In-Reply-To: <20100427124703.GA16706@jgarrett.org>
References: <20100126084740.GA5265@jgarrett.org>
	<87y6jkee1b.fsf@basil.nowhere.org>
	<20100205160900.GA2736@jgarrett.org>
	<alpine.LFD.2.00.1002051238280.4050@localhost.localdomain>
	<20100426194002.586fbaa5@fido5>
	<20100427124703.GA16706@jgarrett.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-RunX1: Yes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 07:47:03 -0500
jeff@jgarrett.org (Jeff Garrett) wrote:


> My board identifies it as a Dell.  No idea if they rebranded a
> gigabyte.
> 
> The patch seems to work for me as well, powertop shows 97.5% c3,
> turbostat shows 93.6% c6 now.  I do get weird latency spikes (on I/O)
> from time to time.
> 
> When I was investigating, I completely configured USB off, and it
> still wouldn't go into deep sleep.  Not sure how well that meshes
> with your UHCI theory.

Does your board expose UHCI controllers or just EHCI with the rate
matching hubs? When you say 'configured USB off'?, do you mean off
in the BIOS or just no drivers?

--phil
