Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965463Ab1GOLAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 07:00:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54954 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964787Ab1GOLAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 07:00:51 -0400
Subject: Re: Dropped IRQ disables Radeon 3D
Date: Fri, 15 Jul 2011 10:53:41 -0000
From: Michael Witten <mfwitten@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Arnuschky <arnuschky@xylon.de>, linux-kernel@vger.kernel.org
Message-ID: <15f2d51a1ab5412a9d7c327ab67b8166-mfwitten@gmail.com>
In-Reply-To: <1310720984.4968.313.camel@pasglop>
References: <d74f405530c34a2f9fdae3d7cf37e0fcmfwitten@gmail.com>
            <0fe54f4a77b64475b9e6041d9ef5772b-mfwitten@gmail.com>
            <1310720984.4968.313.camel@pasglop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jul 2011 19:09:44 +1000, Benjamin Herrenschmidt wrote:

> On Fri, 2011-07-15 at 08:20 +0000, Michael Witten wrote:
>> 
>> Arnuschky wrote to me about this related Debian bug report:
>> 
>>   Fri, 2010-06-18 10:21:05 +0000
>>   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=586312
>> 
>> I popped over to #radeon on freenode where user agd5f told me to
>> try the following on the kernel command line:
>> 
>>   pci=nomsi
>> 
>> After reading about MSIs and the requisite CONFIG_* settings, I
>> realized that I didn't even have MSI support in the kernel anyway.
>> Then agd5f suggested the following patches by Benjamin Herrenschmidt
>> might be of help:
>
> Another problem I noticed is some cards, when not using MSIs, still seem
> to shoot an MSI with whatever value was last programmed into the MSI
> configuration space. Can you check with lspci -vv if there's a non-0
> value in there ? It -could- be that your get bogus MSIs.

So, you want me to boot my Linux version that doesn't have MSI support
and check whether `sudo lspci -vv' says that it is using MSIs?
