Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754773Ab0IPSSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 14:18:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48693 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0IPSSW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 14:18:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=Tsuk7Mv3SLV89bNNwlhQTTimgicwjYWv++9jadsxaLpGTKhpEYhjKgiO+0q4SE+LRK
         YiPapae/jM8sbCsUp5OAckIZUgZJkD8XZfHMDSkCCwI1VrY5BRVpN80QrRMgaa949wh7
         3tKNBv/eK8Zg8m0r6QCU4yDUv/Fz+JZB4yjv8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Nils Radtke <lkml@think-future.de>
Subject: Re: INFO: inconsistent lock state
Date: Thu, 16 Sep 2010 20:18:16 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4; KDE/4.4.5; i686; ; )
Cc: "Linux Kernel-Liste" <linux-kernel@vger.kernel.org>
References: <20100913145102.GI25129@localhost>
In-Reply-To: <20100913145102.GI25129@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201009162018.16966.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 13 września 2010 o 16:51:02 Nils Radtke wrote:
>   Hi,
> 
>   Got this in the logs:
> 
> PM: Adding info for No Bus:vcs7
> PM: Adding info for No Bus:vcsa7
> initialized framebuffer f62c8580 with backing bo f62c0080
> 
> =================================
> [ INFO: inconsistent lock state ]
> 2.6.35.4 #11

Older versions works OK? eg. 2.6.35 or 2.6.34?

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
