Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0FVVqn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 17:46:43 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46861 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0FVVqm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 17:46:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:subject:from:to:user-agent:mime-version
         :content-type:content-transfer-encoding:x-priority:importance;
        b=c9bT+w7dfHHDskQ2zeOHBLKCI+/uTjY0Mqo07WukUf7BrdPJORCmJeNw2HvXf7dCT+
         Y4u2Y5YxJXQZhRhLsFrXeXG9hi5qedPJ6hWBC4CLGQ3Kj28skYa0iJWIO+l+wBJ0C64U
         MbebBSSrVXpu9dRS7YbuB29pgnGDAqSGJslFQ=
Message-ID: <2efe1ee4c89fc45db96e557aee2c29b7.squirrel@localhost>
Date: Tue, 22 Jun 2010 16:21:43 -0500
Subject: PCI Non-transparent bridge support?
From: david.hagood@gmail.com
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.20
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is anybody working on supporting configuring PCI non-transparent bridges
in Linux?

For anybody who does NOT know what a non-transparent bridge is: an NTB is
a device that connects as a PCI device on two separate PCI root complexes.
It then allows each root complex to map regions of its PCI address space
into the address space of the other root complex. It is, in effect, a
"null-modem" for PCI.

You cannot directly connect two root complexes (e.g. just tie 2 computers
together) by connecting their PCI buses - each root complex wants to be
"in charge". The NTB allows each root complex to view the other as a PCI
device exporting some number of base address registers (BARs), and by
accessing one of those BARs the other root complex sees a PCI device (the
NTB) doing a bus master operation on its bus.

For a project for my employer I need a driver for NTBs - I'm going to try
to get all the permissions to GPL it and submit it to the kernel, but
obviously if somebody else is working on this I'd rather work with them.

I'm using my personal email here, as my work email
(david.hagood@aeroflex.com) unfortunately has a paragraph of legalese
attached by the email system.


