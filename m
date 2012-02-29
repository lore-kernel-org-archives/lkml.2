Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965932Ab2B2SRP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 13:17:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:32786 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965845Ab2B2SRO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 13:17:14 -0500
Message-ID: <4F4E6B98.2090306@zytor.com>
Date: Wed, 29 Feb 2012 10:16:56 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: "Joshua C." <joshuacov@googlemail.com>
CC: Bodo Eggert <7eggert@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: [RESUBMIT] [PATCH] Use BIOS Keyboard variable to set Numlock
References: <CAKL7Q7qU0OKzqC-XnM1mY7YWs1SstayqH-8P-5MY3Yg7_wrQZw@mail.gmail.com> <4F4BF11E.4090000@zytor.com> <CAKL7Q7pK_jacfk9shdNootT46AihgABZkN54sbP-SnhA6-1F8Q@mail.gmail.com> <4F4C1F76.70403@zytor.com> <alpine.DEB.2.00.1202281927130.24649@be10.lrz> <4F4D1E6A.5000200@zytor.com> <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
In-Reply-To: <CAKL7Q7oxYvkgvHgqejzRn+OQqCVg2NOqPPs+T_jBvKAigNKCjQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/29/2012 03:43 AM, Joshua C. wrote:
>
> I got the idea that we should somehow check the kbd_state and set the
> numlock accordingly but this is behind my capabilities. I tried
> several times to read those boot_params but I have no idea how to do
> it. Where are they stored, how to access them? Help anyone?
>

There is a global variable called boot_params; the prototype for it is 
defined in <asm/setup.h>.

So as long as you are on an x86 architecture you can just #include 
<asm/setup.h> and just access the boot_params structure directly (with 
the patch provided to add the new field.)

	-hpa
