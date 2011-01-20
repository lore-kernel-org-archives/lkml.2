Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755128Ab1ATG4x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 01:56:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54619 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754414Ab1ATG4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 01:56:51 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=HB/GcFk9E5IhEsKAbeQvSASUT+ptA3yxmbS0BrAOY1VLc6oTt///PIAbvrFij4MtlG
         rd7/BwuS5uxiV51FDpxiY+6auUg+tFcctVvWbW9H4wK8AfM65VNr0dJYo+auDH1+tM8X
         1Z+osP3fYTv3QQw3d4UvKmvAvqVRMvgA2Z3s8=
Message-ID: <4D37DCB7.9010505@gmail.com>
Date: Thu, 20 Jan 2011 07:56:55 +0100
From: Thomas Weber <thomas.weber.linux@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101220 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Thomas Weber <weber@corscience.de>, linux-omap@vger.kernel.org,
        Daniel Morsing <daniel.morsing@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        charu@ti.com, sshtylyov@mvista.com
Subject: Re: [PATCHv4 2/4] OMAP3: Devkit8000: Fix tps65930 pullup/pulldown
 configuration
References: <1295425166-25540-1-git-send-email-weber@corscience.de> <1295425166-25540-3-git-send-email-weber@corscience.de> <20110119222126.GI4957@atomide.com>
In-Reply-To: <20110119222126.GI4957@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.01.2011 23:21, schrieb Tony Lindgren:
> * Thomas Weber <weber@corscience.de> [110119 00:18]:
>> From: Daniel Morsing <daniel.morsing@gmail.com>
>>
>> gpio7 on the tps65930 is used as an output on the devkit8000 and
>> gpio1 is not connected. Remove gpio7 and change gpio1 to pulldown
>>
>> Signed-off-by: Daniel Morsing <daniel.morsing@gmail.com>
> 
> I'll queue only this fix for now, looks like the other still need
> minor changes.
> 
> Tony
> --

Thanks.
