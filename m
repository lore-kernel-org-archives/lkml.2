Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757906Ab2B2LnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:43:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42364 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757814Ab2B2LnF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:43:05 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of joshuacov@googlemail.com designates 10.236.175.36 as permitted sender) smtp.mail=joshuacov@googlemail.com; dkim=pass header.i=joshuacov@googlemail.com
MIME-Version: 1.0
In-Reply-To: <4F4D1E6A.5000200@zytor.com>
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com>
	<4F4BF11E.4090000@zytor.com>
	<CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com>
	<4F4C1F76.70403@zytor.com>
	<alpine.DEB.2.00.1202281927130.24649@be10.lrz>
	<4F4D1E6A.5000200@zytor.com>
Date: Wed, 29 Feb 2012 12:43:05 +0100
Message-ID: <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
From: "Joshua C." <joshuacov@googlemail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/28 H. Peter Anvin <hpa@zytor.com>:
> On 02/28/2012 10:32 AM, Bodo Eggert wrote:
>>
>> Asking the BIOS is as correct as querying the memory location (defined
>> to have same result), but more expensive.
>
>
> Not quite, in reality; it is more likely to work on systems which implement
> various kinds of bypass schemes.  The key aspect of this, though, is that
> this is done on a BIOS path and not by groping a memory location which may
> not even be initialized on non-BIOS systems.
>
>        -hpa

I got the idea that we should somehow check the kbd_state and set the
numlock accordingly but this is behind my capabilities. I tried
several times to read those boot_params but I have no idea how to do
it. Where are they stored, how to access them? Help anyone?
