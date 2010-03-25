Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab0CYQS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:18:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:37710 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751316Ab0CYQS0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=i2h9xClff9+hq3zbgNnFuZ0fOETUpEFZk6icibBMPuM6j9N6KRgtwLNDt64HMgBvmP
         VL/iUvCg2GoC0SRPcEC5CmgARAP68ml0JHm72bI1SZUDUyzpKm52K6q/I7cOkCMf3L4n
         tYRj8DdZGv18/LxmHA6uhflHHXpOlDWlEF0a0=
MIME-Version: 1.0
In-Reply-To: <4BAB8A48.1080409@oracle.com>
References: <201003242215.o2OMFZQ9030208@imap1.linux-foundation.org>
	 <c1f41c621003250850s7552abb6h98ba57d51fe313e1@mail.gmail.com>
	 <4BAB8A48.1080409@oracle.com>
Date: Thu, 25 Mar 2010 23:18:24 +0700
Message-ID: <c1f41c621003250918m631643eq1e02cee2060abdff@mail.gmail.com>
Subject: Re: mmotm 2010-03-24-14-48 uploaded
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 25, 2010 at 11:07 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On 03/25/10 08:50, Emmanuel Benisty wrote:
>> hi Andrew,
>>
>> On Thu, Mar 25, 2010 at 4:48 AM,  <akpm@linux-foundation.org> wrote:
>>> The mm-of-the-moment snapshot 2010-03-24-14-48 has been uploaded to
>>>
>>>   http://userweb.kernel.org/~akpm/mmotm/
>>>
>>> and will soon be available at
>>>
>>>   git://zen-kernel.org/kernel/mmotm.git
>>
>> build fails with:
>>
>> drivers/net/wireless/iwlwifi/iwl-rx.c: In function ‘iwl_good_ack_health’:
>> drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: ‘struct iwl_priv’
>> has no member named ‘_agn’
>> drivers/net/wireless/iwlwifi/iwl-rx.c: In function ‘iwl_rx_reply_rx’:
>> drivers/net/wireless/iwlwifi/iwl-rx.c:1224: warning: ‘noise’ is
>> deprecated (declared at include/net/mac80211.h:557)
>> drivers/net/wireless/iwlwifi/iwl-rx.c:1226: warning: ‘noise’ is
>> deprecated (declared at include/net/mac80211.h:557)
>> make[4]: *** [drivers/net/wireless/iwlwifi/iwl-rx.o] Error 1
>> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
>> make[2]: *** [drivers/net/wireless] Error 2
>> make[1]: *** [drivers/net] Error 2
>> make: *** [drivers] Error 2
>> make: *** Waiting for unfinished jobs....
>
> Patch (for error) is here:
>  http://marc.info/?l=linux-wireless&m=126946621910346&w=2

works. thanks Randy.
