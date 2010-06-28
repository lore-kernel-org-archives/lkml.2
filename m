Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507Ab0F1RsI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 13:48:08 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48995 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab0F1RsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 13:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MA7jjBx5ScVUCFw2LXgSd27T4ROxywZXggtR/Rw7Fh2v1+C9kAk0+BNAX4QZd2Iwfx
         AkIPN2Gaj42VxdCH5e3LvoNLpBFH1F3Y8daZWx892tk9xY5mGrdYV1ah1MJXGzdeeAbj
         ldMGbvF/DX44UtiiMSC8w85sV5BTCoa9T4Qz0=
Message-ID: <4C28E067.6070004@gmail.com>
Date: Mon, 28 Jun 2010 10:48:23 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: linux-kernel@vger.kernel.org, sds@tycho.nsa.gov, lenb@kernel.org,
       linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 1/5]security:key.c Fix warning: variable 'key' set but
 not used
References: <1277621246-10960-2-git-send-email-justinmattock@gmail.com> <1277621246-10960-1-git-send-email-justinmattock@gmail.com> <5104.1277728717@redhat.com>
In-Reply-To: <5104.1277728717@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 05:38 AM, David Howells wrote:
> Justin P. Mattock<justinmattock@gmail.com>  wrote:
>
>> In this case the safest approach(in my mind) would be to just
>> mark the integer __unused. Keep in mind though Im not certain
>> if this is the right place for this value i.e. will this effect
>> *instkey or not(please check).
>
> This is the wrong approach.  Either the variable should be got rid of, or it
> should be used to replace all the other calls to key_ref_to_ptr() in
> keyctl_describe_key().
>
> David
>

I see your patch you sent for this.. vary nice!

Thanks!

Justin P. Mattock
