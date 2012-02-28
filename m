Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965881Ab2B1Sc7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 13:32:59 -0500
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:44319 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932099Ab2B1Sc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 13:32:58 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-17.arcor-online.net 2CC98CC116
Date: Tue, 28 Feb 2012 19:32:56 +0100 (CET)
From: Bodo Eggert <7eggert@gmx.de>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Joshua C." <joshuacov@googlemail.com>, linux-kernel@vger.kernel.org,
        Bodo Eggert <7eggert@gmx.de>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
In-Reply-To: <4F4C1F76.70403@zytor.com>
Message-ID: <alpine.DEB.2.00.1202281927130.24649@be10.lrz>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Feb 2012, H. Peter Anvin wrote:
> On 02/27/2012 04:08 PM, Joshua C. wrote:

>> If so I'm not sure about it. We check the BIOS data area as defined
>> for IBM PCs (1981), so a fair amount of user should benefit from the
>> change. Those non-BIOS boots can set the numlock=0 and won't be
>> affected by this. I think this isa lot easier to implement than doing
>> it in the BIOS bootstrap code.
>>
>
> Here is a patch to query the BIOS state properly; if you could fill out
> the rest of the patch then we can merge this in easily enough.

Asking the BIOS is as correct as querying the memory location (defined to 
have same result), but more expensive.
