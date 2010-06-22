Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab0FVSeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 14:34:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53829 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab0FVSeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 14:34:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MglhrPuJKDXdvhf5iI+sSaIwSK8MIy+J0SPmrjubYvVzJGaNym5fZGbj+DxESdfH8i
         wrjvAdOomXoDtUpsGAKJHS1l7ONKFUxu1hsqwlWYAqlg7k2/0PwK07UkSx2XTvWe7T1t
         3e6nkmMeYkERI7VRWQiXd8M6vtCGCBydG9u0Q=
Message-ID: <4C210236.3030401@gmail.com>
Date: Tue, 22 Jun 2010 11:34:30 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100615 Lightning/1.0b2pre Thunderbird/3.0.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5 v2]wireless:hostap_main.c warning: variable 'iface'
 set but not used
References: <1277157733-14071-1-git-send-email-justinmattock@gmail.com> <20100622181320.GD2583@tuxdriver.com>
In-Reply-To: <20100622181320.GD2583@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/22/2010 11:13 AM, John W. Linville wrote:
> On Mon, Jun 21, 2010 at 03:02:13PM -0700, Justin P. Mattock wrote:
>> This is a resend from version one due to trying a different approach
>> than the original(probably important to leave netdev_priv() in).
>>
>> In any case have a look, if there's another approach let me know
>> and ill test it out. The below patch fixes a warning im seeing
>> when compiling with gcc 4.6.0
>>
>> CC [M]  drivers/net/wireless/hostap/hostap_main.o
>> drivers/net/wireless/hostap/hostap_main.c: In function 'hostap_set_multicast_list_queue':
>> drivers/net/wireless/hostap/hostap_main.c:744:27: warning: variable 'iface' set but not used
>>   Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>
> I already applied the other version to wireless-next-2.6.  I can't
> imagine what you mean to accomplish by leaving in a call to netdev_priv
> w/o assigning the result to something.
>
> John

alright..
as for the netdev_priv, I was getting confused on this one.

Thanks for taking the time to look at this.

Justin P. Mattock
