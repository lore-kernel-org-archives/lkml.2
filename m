Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1CEI0f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 03:26:35 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42933 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CEI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 03:26:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=I7Oz56tT1IaExtvFdzT9S7t4vKvZtqcOEczowk49z+4fm0nm85p5KFTRx/BYwts4CK
         B3EDh0CFny+0BjnKThj9ex/8jfGDgb190DIMUZCMJtQNjpgO39CgrieXaNNNp0v2g6G1
         7WhR8fTxi8M4HSYvYsrek0qzW80c3Y4LEdX58=
Message-ID: <4D71F3B5.7080803@suse.cz>
Date: Sat, 05 Mar 2011 09:26:29 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.14) Gecko/20110221 SUSE/3.1.8 Thunderbird/3.1.8
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        netdev@vger.kernel.org, maxk@qualcomm.com
Subject: Re: tun routing is broken
References: <20110304.010603.104076956.davem@davemloft.net>	<4D70B2DC.2000005@gmail.com>	<4D71EE86.6030309@suse.cz> <20110305.001022.183044112.davem@davemloft.net> <4D71F194.9010402@suse.cz>
In-Reply-To: <4D71F194.9010402@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2011 09:17 AM, Jiri Slaby wrote:
>> ipv4: Fix __ip_dev_find() to use ifa_local instead of ifa_address.
> 
> It would be great to have a References: tag or better changelog. Then I
> would give the commit a shot. The way it is I ignored it when looking at
> next/master inside net/ipv4/ changes for commits to test.
> 
> Going to boot with this change.

Yes, it works.

thanks,
-- 
js
suse labs
