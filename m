Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759609Ab2EQGoJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 02:44:09 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:53842 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759137Ab2EQGoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 02:44:08 -0400
Message-ID: <4FB49E74.8030409@mev.co.uk>
Date: Thu, 17 May 2012 07:45:08 +0100
From: Ian Abbott <abbotti@mev.co.uk>
Organization: MEV Ltd
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>,
        Ian Abbott <ian.abbott@mev.co.uk>
Subject: Re: [PATCH] staging: comedi: Convert struct addi_board initialization
 to C99 format
References: <201205161751.56913.hartleys@visionengravers.com>,<20120517021805.GA32592@kroah.com> <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206986FBDDF@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/05/12 07:15, H Hartley Sweeten wrote:
> Wednesday, May 16, 2012 7:18 PM, Greg KH wrote:
>> On Wed, May 16, 2012 at 05:51:56PM -0700, H Hartley Sweeten wrote:
>>> Convert the struct addi_board initialization to C99 format and remove
>>> all the NULL or 0 initializers. This makes maintaining and editing the
>>> code simpler and less error prone.
>> Nice job, this driver is a pain to read...
>
> Thanks. I agree... I've been avoiding the addi drivers until now.
> Anytime a C file has an #include "something.c" it makes me
> shudder...
>
> I've been thinking that the addi stuff should really be broken up
> into some library modules with exported symbols for the individual
> addi drivers to use. I need to look a bit closer at them to see if
> this would work. Right now the whole thing is a bit of a mess.

TBH, I don't know how they got accepted into Comedi in the first place. 
  They tend to do their own thing as far as comedi instruction handling 
goes.  I've no idea who's using them.  It makes me shudder, too!  Did I 
mention the use of floating point in some of their drivers that we had 
to disable?

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
