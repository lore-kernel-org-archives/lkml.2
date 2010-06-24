Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755810Ab0FXTUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 15:20:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57716 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751365Ab0FXTUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 15:20:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tqmGDZumdCadSYt1LAmSVP2d3g3U1TEgi784Uayf+bXZR8SwHBeU0z+ikx02Jkckbw
         U/xAVddcmwPThkLb64f6s6pH00dgmPfa5JijToLuuNXP+H+BfvrqVVL+jCTYl9JUoHs6
         BzpcP8L5AsnytmULMoNXF3Vak2zyOqf/Nd/Zw=
Message-ID: <4C23B01A.6020901@lwfinger.net>
Date: Thu, 24 Jun 2010 14:20:58 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4 Thunderbird/3.0.4
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: Joe Perches <joe@perches.com>, Stefano Brivio <stefano.brivio@polimi.it>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, mb@bu3sch.de, zajec5@gmail.com
Subject: Re: [PATCH 0/3] b43: logging cleanups
References: <cover.1276988387.git.joe@perches.com> <20100624185339.GC2368@tuxdriver.com>
In-Reply-To: <20100624185339.GC2368@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2010 01:53 PM, John W. Linville wrote:
> On Sat, Jun 19, 2010 at 04:30:08PM -0700, Joe Perches wrote:
>> Just some small cleanups
>>
>> Joe Perches (3):
>>   drivers/net/wireless/b43: Use local ratelimit_state
>>   drivers/net/wireless/b43: Logging cleanups
>>   drivers/net/wireless/b43: Rename b43_debug to b43_debugging
> 
> Any of the b43 guys want to express an opinion on these?

The local ratelimit patch is OK. My personal opinion is that the others
are just churning the source for no real reason, but I have no major
objections.

Larry
