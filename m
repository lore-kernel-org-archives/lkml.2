Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0CYQIX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 12:08:23 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:55498 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492Ab0CYQIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 12:08:22 -0400
Message-ID: <4BAB8A48.1080409@oracle.com>
Date: Thu, 25 Mar 2010 09:07:36 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Emmanuel Benisty <benisty.e@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-03-24-14-48 uploaded
References: <201003242215.o2OMFZQ9030208@imap1.linux-foundation.org> <c1f41c621003250850s7552abb6h98ba57d51fe313e1@mail.gmail.com>
In-Reply-To: <c1f41c621003250850s7552abb6h98ba57d51fe313e1@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4BAB8A72.0146:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/10 08:50, Emmanuel Benisty wrote:
> hi Andrew,
> 
> On Thu, Mar 25, 2010 at 4:48 AM,  <akpm@linux-foundation.org> wrote:
>> The mm-of-the-moment snapshot 2010-03-24-14-48 has been uploaded to
>>
>>   http://userweb.kernel.org/~akpm/mmotm/
>>
>> and will soon be available at
>>
>>   git://zen-kernel.org/kernel/mmotm.git
> 
> build fails with:
> 
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function ‘iwl_good_ack_health’:
> drivers/net/wireless/iwlwifi/iwl-rx.c:647: error: ‘struct iwl_priv’
> has no member named ‘_agn’
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function ‘iwl_rx_reply_rx’:
> drivers/net/wireless/iwlwifi/iwl-rx.c:1224: warning: ‘noise’ is
> deprecated (declared at include/net/mac80211.h:557)
> drivers/net/wireless/iwlwifi/iwl-rx.c:1226: warning: ‘noise’ is
> deprecated (declared at include/net/mac80211.h:557)
> make[4]: *** [drivers/net/wireless/iwlwifi/iwl-rx.o] Error 1
> make[3]: *** [drivers/net/wireless/iwlwifi] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2
> make: *** Waiting for unfinished jobs....

Patch (for error) is here:
  http://marc.info/?l=linux-wireless&m=126946621910346&w=2

-- 
~Randy
