Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758784Ab1CCUpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:45:16 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:41589 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758472Ab1CCUpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:45:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ENgdcfvEiKDGltH+dh+9YP1T70XqcBeBmRuaiaOOtK6MO7ILlBnSDRdmvMWkxxe6eU
         uWyYlYeYuJkdGBZVR1dgkFAEXbUzErRTO1uKiFRxppROJMmyWOJ5SlKMOtaNkwq6i+NV
         QZdSaeGlm9vBTOINQUjZi+5nLBoAnt+d2RPxk=
Message-ID: <4D6FFDD3.8070206@gmail.com>
Date: Thu, 03 Mar 2011 23:45:07 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Henrik Kretzschmar <henne@nachtwindheim.de>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7] x86: make apic_disable() static and init
References: <1299182701-8591-1-git-send-email-henne@nachtwindheim.de> <1299182701-8591-3-git-send-email-henne@nachtwindheim.de>
In-Reply-To: <1299182701-8591-3-git-send-email-henne@nachtwindheim.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2011 11:04 PM, Henrik Kretzschmar wrote:
> apic_disable() is only used in apic.c, so it does not
> need the prototype which was introduced inc commit
> 08306ce61d6848e6fbf74fa4cc693c3fb29e943f .
> Therefore we remove it from the header and make it static.
> 
> It is also called only from init code, so we mark it as such.
> 
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>
> ---

Thanks for cleanup Henrik!
(nb: Please always CC an commit's author next time.)

Acked-by: Cyrill Gorunov <gorcunov@openvz.org>
-- 
    Cyrill
