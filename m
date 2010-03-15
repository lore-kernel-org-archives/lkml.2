Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937134Ab0COXGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 19:06:38 -0400
Received: from mail-pz0-f200.google.com ([209.85.222.200]:50620 "EHLO
	mail-pz0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937057Ab0COXGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 19:06:34 -0400
Message-ID: <4B9EBD77.6070400@earthdetails.com>
Date: Mon, 15 Mar 2010 16:06:31 -0700
From: Reza Roboubi <reza@earthdetails.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Tilera multi core: power consumption, design, performance (comments
 please)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LKML is very quite about the Tilera multi core chip.  I'm wondering why 
that is?

I know the debate about RISC/VLIW vs. non-RISC/OoO.  However, what do 
people think about the overall performance of Tilera given it's low 
power consumption (~55 watts) as far as it's intended (parallelizable) 
applications are concerned?

I looked at the Tilera patent number 7,636,835.  It looks like a decent 
directory based cache coherency solution that is very scalable.

So, please give comments if you can.
Why is the chip not discussed at LKML?  Is it cost or lack of documentation?

Thanks.

Reza.
