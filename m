Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab1CDJhj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:37:39 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38279 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758903Ab1CDJhh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:37:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=x6s1vLqsfHPwKD4PxAi5oZDZhUFMFDcNxYydR/rXjL+ou3HCXg4Cvn3xvzGO219jpT
         QzR10Syped8+2V7Moiy4KMb6d2G59+b7EiPNOLyktNsA19va23K4Rs/t5VJPcnUKn9ZX
         OSp1T3x1zpbhOeNuNLLCF/lp2X9HQuZtl1NkQ=
Message-ID: <4D70B2DC.2000005@gmail.com>
Date: Fri, 04 Mar 2011 10:37:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: jslaby@suse.cz, linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, netdev@vger.kernel.org, maxk@qualcomm.com,
        vtun@office.satix.net
Subject: Re: tun: Failed to create tun sysfs files
References: <201103030127.p231ReNl012841@imap1.linux-foundation.org>	<4D70A929.4010900@suse.cz> <20110304.010603.104076956.davem@davemloft.net>
In-Reply-To: <20110304.010603.104076956.davem@davemloft.net>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2011 10:06 AM, David Miller wrote:
> From: Jiri Slaby <jslaby@suse.cz>
> Date: Fri, 04 Mar 2011 09:56:09 +0100
> 
>> On 03/03/2011 01:52 AM, akpm@linux-foundation.org wrote:
>>> The mm-of-the-moment snapshot 2011-03-02-16-52 has been uploaded to
>>
>> Hi, I'm seeing this with tun (also with earlier versions):
> 
> The name of the attribute was changed to netdev_group in order to
> fix this problem, in fact quite some time ago.
> 
> See the last entry of the net_class_attributes array in
> net/core/net-sysfs.c, if it isn't called "netdev_group"
> something is awry.

<idiocy>
Aha, sorry for the noise, I booted the old kernel.
</idiocy>

thanks,
-- 
js
