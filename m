Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab0HCKLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:11:34 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64581 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0HCKLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:11:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=S7UkTNsaqDOOTuCVdaApulnzstP2s1DoVvNJLfayKRzrbBBNZMdpGDSxYFW8/Za36j
         M8+rHazcHjruiI/WM0JVYMcpfBR5TGnlz2VCDUYqh0idCuCK4nxkhv0dEuj/hL6Q2z9C
         FuVypTOa4cefpABWwgfCOqC5u2eptb/Rx83Zc=
Date: Tue, 3 Aug 2010 18:15:44 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Boaz Harrosh <openosd@gmail.com>
Cc: hacklu <embedway.linux@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how about KBUILD_MODNAME
Message-ID: <20100803101544.GJ5129@cr0.nay.redhat.com>
References: <201008031037022524247@gmail.com>
 <201008031511572638256@gmail.com>
 <4C57E6F9.6080104@panasas.com>
 <4C57E7EB.4090904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C57E7EB.4090904@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 03, 2010 at 12:56:59PM +0300, Boaz Harrosh wrote:
>On 08/03/2010 12:52 PM, Boaz Harrosh wrote:
>> On 08/03/2010 10:11 AM, hacklu wrote:
>>>
>>> I don't understand the macro KBUILD_MODNAME .
>>> when I compile a  driver program. It returns me "linux/pci.h:655: error: 'KBUILD_MODNAME' undeclared (first use in this function) "
>>>
>>> In the makefile I had used the "-D" options
>>>
>>> thanks a lot
>>>
>>> 2010-08-03 
>>>
>>> hacklu 
>>>
>> 
>> The KBUILD_MODNAME fails to be set when there are two drivers built from the same
>> directory. There are many directories in the source tree with more then one driver
>> but they don't use the pr_debug macro.
>> 
>> Cheers
>> Boaz
>
>Rrr it was a long time since I fought this. Maybe it's not the problem with two
>drivers in same dir, maybe it's when two drivers share the same foo.c file.
>

No, it is not, you can find many drivers under drivers/net/. ;)

And it doesn't make sense to hold two drivers in one .c file.
