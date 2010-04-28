Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0D1WtF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 18:49:05 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:59622 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755534Ab0D1WtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 18:49:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oknm0bunyHPNkzO5EwsBaTn7GfrKWZl+fYV5EqkAU+CXilOoLqIiiqn+mx4hzYK4HV
         woV1NjPE+5Yv9iBaYqU/vtmOv7jdWx7RRUHGE3/fLG5NT33IAZDdSEv9PmDGiWg/m9W8
         //JEAo2LTT+4h9C3Zx4luLfxZYDMpMBGR1ufM=
Message-ID: <4BD8BB59.2080608@gmail.com>
Date: Thu, 29 Apr 2010 00:48:57 +0200
From: Roel Van Nyen <roel.vannyen@gmail.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: gregkh@suse.de, hjanssen@microsoft.com, haiyangz@microsoft.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: hv: Fix coding style errors in NetVsc.c
References: <1272491748-12516-1-git-send-email-roel.vannyen@gmail.com> <20100428220906.GA14160@kroah.com>
In-Reply-To: <20100428220906.GA14160@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:

> On Wed, Apr 28, 2010 at 11:55:48PM +0200, Roel Van Nyen wrote:
>   
>> Fix coding style issues
>>
>> Signed-of-by: Roel Van Nyen <roel.vannyen@gmail.com>
>> ---
>>  drivers/staging/hv/NetVsc.c |    4 ++--
>>     
>
> This fix has already been made in the linux-next tree.  Can you make
> sure you work off of it, and not an older tree in the future?
>
> thanks,
>
> greg k-h
>   
I will update my next tree more frequent.

thanks,
roel

