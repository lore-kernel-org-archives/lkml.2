Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab1CEQaP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 11:30:15 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:52703 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1CEQaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 11:30:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=sq6D9Wm7RG9NvyflJyeRLqT47592wemw0Zdgb6g23JcVwbC/qqmEB7shjFTGfRNc+K
         hF4y33cWkT1DzNR4C8mUfKLnl/iJ3D9pQ6s1zCAEh9l9U8p+lKd7yYObzPJB/GiY4srd
         /H0nh0JTUxl4/fMG3UbKGckbcud7o3SlRy4Ss=
Message-ID: <4D72650D.8070503@lwfinger.net>
Date: Sat, 05 Mar 2011 10:30:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jovi Zhang <bookjovi@gmail.com>
CC: Ben Hutchings <bhutchings@solarflare.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:NETWORKING [WIREL..." <linux-wireless@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: mac80211: fix compilation warning
References: <1299108754-5492-1-git-send-email-bookjovi@gmail.com>	<1299328260.4277.92.camel@localhost> <AANLkTimnSvBKSL6_d3RxufxUL_C9wCM+Fz66_B5Sc0KE@mail.gmail.com>
In-Reply-To: <AANLkTimnSvBKSL6_d3RxufxUL_C9wCM+Fz66_B5Sc0KE@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 07:52 AM, Jovi Zhang wrote:
> On Sat, Mar 5, 2011 at 8:31 PM, Ben Hutchings<bhutchings@solarflare.com>  wrote:
>> On Wed, 2011-03-02 at 18:32 -0500, bookjovi@gmail.com wrote:
>>> From: Jovi Zhang<bookjovi@gmail.com>
>>>
>>> this commit fix compilation warning as following:
>>> net/mac80211/tx.c:1753: warning: unused variable mppath
>> [...]
>>
>> You clearly didn't try building this with CONFIG_MAC80211_MESH enabled.
>>
> Sorry, indeed, maybe should be like this:
>
> +#ifdef CONFIG_MAC80211_MESH
>         struct mesh_path *mppath = NULL;
> +#endif

Linville likes "struct mesh_path *mppath __maybe_unused = NULL;" over the ifdef 
form.

Larry
