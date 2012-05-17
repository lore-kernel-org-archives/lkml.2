Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138Ab2EQP5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:57:54 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:54856 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755060Ab2EQP5w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:57:52 -0400
Message-ID: <4FB51FFA.3090800@mev.co.uk>
Date: Thu, 17 May 2012 16:57:46 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 5.2; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH] staging: comedi: Convert struct addi_board initialization
 to C99 format
References: <201205161751.56913.hartleys@visionengravers.com> <20120517021805.GA32592@kroah.com> <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net> <4FB49E74.8030409@mev.co.uk> <20120517133221.GB5090@kroah.com>
In-Reply-To: <20120517133221.GB5090@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/05/17 02:32 PM, Greg KH wrote:
> On Thu, May 17, 2012 at 07:45:08AM +0100, Ian Abbott wrote:
>> On 17/05/12 07:15, H Hartley Sweeten wrote:
>>> Wednesday, May 16, 2012 7:18 PM, Greg KH wrote:
>>>> On Wed, May 16, 2012 at 05:51:56PM -0700, H Hartley Sweeten wrote:
>>>>> Convert the struct addi_board initialization to C99 format and remove
>>>>> all the NULL or 0 initializers. This makes maintaining and editing the
>>>>> code simpler and less error prone.
>>>> Nice job, this driver is a pain to read...
>>>
>>> Thanks. I agree... I've been avoiding the addi drivers until now.
>>> Anytime a C file has an #include "something.c" it makes me
>>> shudder...
>>>
>>> I've been thinking that the addi stuff should really be broken up
>>> into some library modules with exported symbols for the individual
>>> addi drivers to use. I need to look a bit closer at them to see if
>>> this would work. Right now the whole thing is a bit of a mess.
>>
>> TBH, I don't know how they got accepted into Comedi in the first
>> place.  They tend to do their own thing as far as comedi instruction
>> handling goes.  I've no idea who's using them.  It makes me shudder,
>> too!  Did I mention the use of floating point in some of their
>> drivers that we had to disable?
> 
> I thought a few years ago, either you, or someone else, said it would be
> good to just delete them entirely.  Or am I making that up and just wish
> it would be so?  :)

I can't remember at my age!

There was a guy who works for Addi-Data (Krauth Julien) who had trouble
submitting patches to you directly (I was CC'd) back in
September/October 2011, so I guess they'd be unhappy if the drivers were
removed altogether!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>             )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587              )=-
