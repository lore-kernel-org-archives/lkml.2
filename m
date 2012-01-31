Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab2AaWCx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:02:53 -0500
Received: from mail.candelatech.com ([208.74.158.172]:58411 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab2AaWCw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:02:52 -0500
Message-ID: <4F286508.8000904@candelatech.com>
Date: Tue, 31 Jan 2012 14:02:48 -0800
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: FlorianSchandinat@gmx.de,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Bisected boot hang introduced in 3.0 (2e336b326, "add VIA slapping
 capability")
References: <4F2833B5.5050608@candelatech.com>
In-Reply-To: <4F2833B5.5050608@candelatech.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2012 10:32 AM, Ben Greear wrote:
> I have an embedded VIA system (FWA-7304) that fails to boot on
> 3.0 and higher kernels (tried top-of-tree yesterday, it fails as well).

Ahh, seems I just needed to enable the CONFIG_FB_VIA_X_COMPATIBILITY
logic.  With that, it boots properly.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

