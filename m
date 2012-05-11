Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933162Ab2EKSPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 14:15:06 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:47605 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932215Ab2EKSPE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 14:15:04 -0400
Message-ID: <4FAD5723.1060405@mev.co.uk>
Date: Fri, 11 May 2012 19:14:59 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120414 Thunderbird/11.0.1
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Ian Abbott <ian.abbott@mev.co.uk>,
        "fmhess@users.sourceforge.net" <fmhess@users.sourceforge.net>
Subject: Re: [PATCH] staging: comedi: Add helper macro for comedi pci driver
 boilerplate
References: <201205111007.46754.hartleys@visionengravers.com> <20120511175954.GA7920@kroah.com> <ADE657CA350FB648AAC2C43247A983F0020698A17EA9@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0020698A17EA9@AUSP01VMBX24.collaborationhost.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-05-11 19:04, H Hartley Sweeten wrote:
> On Friday, May 11, 2012 11:00 AM, Greg KH wrote:
>> On Fri, May 11, 2012 at 10:07:43AM -0700, H Hartley Sweeten wrote:
>>> +EXPORT_SYMBOL(comedi_pci_driver_unregister);
>>
>> EXPORT_SYMBOL_GPL() for these two functions?
>
> I wasn't sure about that...
>
> Question.. when "should" EXPORT_SYMBOL be used and
> when should it be EXPORT_SYMBOL_GPL?

Adding EXPORT_SYMBOL_GPL shouldn't remove previous functionality.  It 
doesn't in this case, so that's okay!

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-
