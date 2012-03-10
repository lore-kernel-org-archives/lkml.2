Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab2CJNKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 08:10:43 -0500
Received: from vps1.hno.se ([195.20.207.177]:33031 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753445Ab2CJNKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 08:10:42 -0500
X-Greylist: delayed 1806 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2012 08:10:42 EST
Message-ID: <1331383208.29393.18.camel@home.hno.se>
Subject: Re: [Arm-netbook] [advice sought] EOMA68 kernel support
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: Linux on small ARM machines <arm-netbook@lists.phcomp.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Sat, 10 Mar 2012 13:40:08 +0100
In-Reply-To: <CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
References: <CAPweEDz+seEGbAtE48NfPon66jqvb0sNSMcnC-LnXvmVbF+sbA@mail.gmail.com>
	 <CAPweEDysGTCNp+6SCCpzBorwn5ZczNNgV0E+mBLe0FwfE=3Wqw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (vps1.henriknordstrom.net [IPv6:2a02:750:7::d0a]); Sat, 10 Mar 2012 12:40:11 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lör 2012-03-10 klockan 06:45 +0000 skrev lkcl luke:

>  ... so, real simple very basic, concrete and necessary question:
> where the hell in the linux kernel tree should support for eoma68 be
> added??

Good question.

There is two parts of eoma68 relevant to this

First, there is the capabilitities of the CPU card itself.

Second, there is the I/O board it gets connected to.

These two parts need to be matched, resulting in a device tree or
similar for the actual system in it's current form, and is something
that may even change dynamically at suspend/resume. The I/O board may
cause different I/O profiles to be selected bu the CPU card. A
theoretical example would be one configuraiton having LCD, the other
doing 10 UARTs on the same lines. This requires the CPU card to adopt in
which hardware devices it activates, something ARM SoCs is quite good at
and A10 in particular.

We do not know yet which I/O profiles of EOMA will be available or used
for. The current profile is based on the expected initial target
systems.

The EOMA connector in itself is a kind of I/O bus.

Regards
Henrik

