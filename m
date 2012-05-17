Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967499Ab2EQS2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:28:49 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:54995 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932757Ab2EQS2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:28:46 -0400
Message-ID: <4FB54356.5020203@mev.co.uk>
Date: Thu, 17 May 2012 19:28:38 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Ian Abbott <ian.abbott@mev.co.uk>, Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH] staging: comedi: Convert struct addi_board initialization
 to C99 format
References: <201205161751.56913.hartleys@visionengravers.com> <20120517021805.GA32592@kroah.com> <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net> <4FB49E74.8030409@mev.co.uk> <20120517133221.GB5090@kroah.com> <4FB51FFA.3090800@mev.co.uk> <ADE657CA350FB648AAC2C43247A983F0020698AE0FF8@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698AE0FF8@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/2012 17:38, H Hartley Sweeten wrote:
> On Thursday, May 17, 2012 8:58 AM, Ian Abbott wrote:
>> On 2012/05/17 02:32 PM, Greg KH wrote:
>>> I thought a few years ago, either you, or someone else, said it would be
>>> good to just delete them entirely.  Or am I making that up and just wish
>>> it would be so?  :)
>>
>> I can't remember at my age!
>>
>> There was a guy who works for Addi-Data (Krauth Julien) who had trouble
>> submitting patches to you directly (I was CC'd) back in
>> September/October 2011, so I guess they'd be unhappy if the drivers were
>> removed altogether!
>
> I think they can be cleaned up. It's just going to take a bit of work. Of course
> when it's done they probably will not look anything like they do now.
>
> BTW, what actual hardware do you have available to test with?

Not a lot.  Just the Amplicon cards (amplc_* drivers).

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
