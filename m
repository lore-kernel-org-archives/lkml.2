Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0GVVx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:53:58 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57625 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab0GVVxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:53:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=DaPMR+YJ7Ow7W7eYsX5kaYJ6es0b9GBrl1r5iRgRmHUAXXWcAluXbY/SZ2VKHk9maY
         VE3NN8g/UJpBEMDwTYkWXuEafFQNMbupQ3P5tcLm1Fo/mmk9WNrzQb06PeTny1hg2Wg8
         EnxxcgrXRU3x98PHpXtZ2d+p+d7Bau8r4eQ40=
Message-ID: <4C48BDF0.9050508@gmail.com>
Date: Thu, 22 Jul 2010 22:53:52 +0100
From: Iain <selsinork@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090302)
MIME-Version: 1.0
To: Iain <selsinork@gmail.com>
CC: Len Brown <lenb@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "Yu, Luming" <luming.yu@intel.com>,
        Philip Langdale <philipl@overt.org>, Jeff Garrett <jeff@jgarrett.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "venki@google.com" <venki@google.com>
Subject: Re: [PATCH] ACPI: make acpi_idle Nehalem-aware
References: <20100427124703.GA16706@jgarrett.org> <alpine.LFD.2.00.1004301218280.2489@sony> <20100430174447.GA14889@srcf.ucam.org> <d7f2dd35a4361e5156079278543769a0@localhost> <alpine.LFD.2.00.1005250125590.20648@localhost.localdomain> <CE761E84DADF2947A4AF22FB8D97A4731E0366B5@shsmsx501.ccr.corp.intel.com> <20100525124325.GC7876@srcf.ucam.org> <alpine.LFD.2.00.1005251114420.4114@localhost.localdomain> <20100525185507.GA15997@srcf.ucam.org> <alpine.LFD.2.00.1007211729550.409@localhost.localdomain> <20100722074750.GA22520@one.firstfloor.org> <alpine.LFD.2.00.1007221153120.3164@localhost.localdomain> <4C48B730.30708@gmail.com>
In-Reply-To: <4C48B730.30708@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Iain wrote:
> Len Brown wrote:
>> However, we'll still have issues with systems
>> like the HP DL360 G6 which explicity set the
> 
> I'm curious as to why you see a problem with the DL380G6 as the one I have here happily sits in C6 when idle.

Please ignore me, apologies for the noise.

Just noticed the problem system was a DL360 and mine is a DL380. Long day spent working with both 360's and 380's - I don't seem to 
be able to tell them apart anymore..

Iain
