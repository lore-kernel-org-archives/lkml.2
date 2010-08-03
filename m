Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0HCJ5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 05:57:07 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59046 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755679Ab0HCJ5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 05:57:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FTZFMfM5hjvs75R08SCwLjoAL6y3cJwKTjhWA4/wDIsulrPY+S8YvJw3YYELSmpHhT
         VolRTYnKCQVqsEzRnjbZDF0pBQwGgBlgNCfYDvuGqVtSLSkGZdiv9gZ8iI3j82otH5Px
         COYlNeUHbVz62JjOxBoVXYEdTyFJ2JJ/t6acg=
Message-ID: <4C57E7EB.4090904@gmail.com>
Date: Tue, 03 Aug 2010 12:56:59 +0300
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: hacklu <embedway.linux@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: how about KBUILD_MODNAME
References: <201008031037022524247@gmail.com> <201008031511572638256@gmail.com> <4C57E6F9.6080104@panasas.com>
In-Reply-To: <4C57E6F9.6080104@panasas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 12:52 PM, Boaz Harrosh wrote:
> On 08/03/2010 10:11 AM, hacklu wrote:
>>
>> I don't understand the macro KBUILD_MODNAME .
>> when I compile a  driver program. It returns me "linux/pci.h:655: error: 'KBUILD_MODNAME' undeclared (first use in this function) "
>>
>> In the makefile I had used the "-D" options
>>
>> thanks a lot
>>
>> 2010-08-03 
>>
>> hacklu 
>>
> 
> The KBUILD_MODNAME fails to be set when there are two drivers built from the same
> directory. There are many directories in the source tree with more then one driver
> but they don't use the pr_debug macro.
> 
> Cheers
> Boaz

Rrr it was a long time since I fought this. Maybe it's not the problem with two
drivers in same dir, maybe it's when two drivers share the same foo.c file.

Boaz
