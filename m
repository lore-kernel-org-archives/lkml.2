Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752885Ab0KJAce (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:32:34 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60306 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab0KJAcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:32:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=miSEpy3VoLUosD6qukES3b++Cgch7YWiIOSICElnfd1eGf//YC3Q3/BRXiQx1mGGrs
         MJoWONFgHqpOTTelx8xbWwiwRw3lURyVoI14RCj28yy7Kmk/V0T33FjSVYMvmZAXeKmN
         65I8FZfcuSQQefij7iDAr5rMI7Trm6kZTxNLk=
Message-ID: <4CD9E757.7050608@lwfinger.net>
Date: Tue, 09 Nov 2010 18:29:11 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: r8712u: Fix sparse message
References: <4cc9ef57.olkJXiwQEtL/lNA3%Larry.Finger@lwfinger.net> <20101109235758.GD9001@kroah.com>
In-Reply-To: <20101109235758.GD9001@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2010 05:57 PM, Greg KH wrote:
> On Thu, Oct 28, 2010 at 04:47:03PM -0500, Larry Finger wrote:
>> >From b57eb713ef7d36b2fe10ec83a989ba1845e098b6 Mon Sep 17 00:00:00 2001
>> From: Larry Finger <Larry.Finger@lwfinger.net>
>> Date: Tue, 26 Oct 2010 11:02:25 -0500
>> Subject: [PATCH 2/2] staging: r8712u: Fix sparse message
>>
>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>> ---
>>  drivers/staging/rtl8712/TODO                  |    1 -
>>  drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    1 +
>>  drivers/staging/rtl8712/rtl871x_mp_ioctl.c    |    2 --
>>  drivers/staging/rtl8712/rtl871x_mp_ioctl.h    |    2 +-
>>  4 files changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/rtl8712/TODO b/drivers/staging/rtl8712/TODO
>> index ed22b0b..d8dfe5b 100644
>> --- a/drivers/staging/rtl8712/TODO
>> +++ b/drivers/staging/rtl8712/TODO
>> @@ -3,7 +3,6 @@ TODO:
>>  - switch to use LIB80211
>>  - switch to use MAC80211
>>  - checkpatch.pl fixes - only a few remain
>> -- sparse fixes
>>  
>>  Please send any patches to Greg Kroah-Hartman <greg@kroah.com>,
>>  Larry Finger <Larry.Finger@lwfinger.net> and
> 
> This part of the patch doesn't apply anymore, which is odd.
> 
> Anyway, care to redo it against linux-next and resend it?

My fault. I have some local changes to use external firmware, and I applied
things in the wrong order. The correct patch is on the way.

Larry
