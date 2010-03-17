Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab0CQGiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:38:16 -0400
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:41031 "EHLO
	postalmail-a4.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753366Ab0CQGiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:38:15 -0400
X-Greylist: delayed 16055 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Mar 2010 02:38:15 EDT
Message-ID: <4BA078D0.6080601@murgatroid.com>
Date: Tue, 16 Mar 2010 23:38:08 -0700
From: Christopher Hoover <ch@murgatroid.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.8) Gecko/20100227 Lightning/1.0b1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for B&B Electronics USPLT4-LS
References: <4BA03A1A.50204@murgatroid.com> <20100317043910.GA21532@suse.de>
In-Reply-To: <20100317043910.GA21532@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/16/2010 9:39 PM, Greg KH wrote:
> On Tue, Mar 16, 2010 at 07:10:34PM -0700, Christopher Hoover wrote:
>    
>> Adds support for B&B Electronics USPLT4-LS.
>>      
> Can you resend this with a "Signed-off-by:" line so that I can apply the
> patch?  The file, Documentation/SubmittingPatches shows what is needed
> here.
>
>    
>> diff --exclude='*~' -Naur linux-2.6.30.orig/drivers/usb/serial/ftdi_sio.c linux-2.6.30/drivers/usb/serial/ftdi_sio.c
>>      
> Can you make the patch against 2.6.33 or even 2.6.34-rc1 if possible?
> The code in this area has changed so you will have to move your patch
> around a bit.
>
> thanks,
>
> greg k-h
>
>    

It looks to me that 2.6.34-rc1 includes the equivalent of the patch I sent.

-ch

