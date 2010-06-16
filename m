Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759498Ab0FPUMr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:12:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54929 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0FPUMq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:12:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=JaX/VNNdxumv4hWJlM9P+yHy13LwahP21jj5DZYeX8tvawCSDeVSWSJnllYaHOcOPp
         cEn1oMQnI/S8Gsx/azaPjg/YhFv0wdeDNGwQIKXcQaMDVGp3iqi8HIInUTpzfF+Xhjpm
         e8l610ZG2DYkIUfmthpIvMM6GcuBvXFyS9Nw8=
From: Maciej Rutecki <maciej.rutecki@gmail.com>
Reply-To: maciej.rutecki@gmail.com
To: Mario Guenterberg <mario.guenterberg@googlemail.com>
Subject: Re: 2.6.35-rc3 - WARNING:iwl_set_dynamic_key
Date: Wed, 16 Jun 2010 22:12:40 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3; KDE/4.4.4; i686; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
References: <20100614115510.GA7904@guenti-laptop>
In-Reply-To: <20100614115510.GA7904@guenti-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201006162212.40550.maciej.rutecki@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On poniedziałek, 14 czerwca 2010 o 13:55:10 Mario Guenterberg wrote:
> Hi,
> 
> I've some sporadically warnings in the 2.6.35-rc3 kernel:
> 
> WARNING: at drivers/net/wireless/iwlwifi/iwl-sta.c:952
> iwl_set_dynamic_key+0x209/0x4e0 [iwlcore]()
> 
> Hardware name: Aspire 8920
> 
> Device: Intel Corporation PRO/Wireless 4965 AG
> or AGN [Kedron] Network Connection (rev 61)
> 
> no space for a new key
> 
> Call Trace:
> [<ffffffff8103ca66>] warn_slowpath_common+0x85/0x9d
> [<ffffffff8103cb21>] warn_slowpath_fmt+0x46/0x48
> [<ffffffffa0d6902a>] iwl_set_dynamic_key+0x209/0x4e0 [iwlcore]
> [<ffffffffa0da1ab5>] iwl_mac_set_key+0x285/0x438 [iwlagn]
> [<ffffffffa01d1ca8>] drv_set_key+0x57/0x62 [mac80211]
> [<ffffffffa01d1fa4>] __ieee80211_key_todo+0x146/0per+0x0/0x10
> [<ffffffffa01d218e>] ieee80211_key_todo+0x1a/0x28 [mac80211]
> [<ffffffffa01d21aa>] key_todo+0xe/0x10 [mac80211]
> [<ffffffff81051826>] worker_thread+0x1a6/0x22d
> [<ffffffffa01d219c>] ? key_todo+0x0/0x10 [mac80211]
> [<ffffffff81055591>] ? autoremove_wake_function+0x0/0x39
> [<ffffffff81051680>] ? worker_thread
> 
> OS: Fedora 13 x86_64
> 

I created a Bugzilla entry at 
https://bugzilla.kernel.org/show_bug.cgi?id=16232
for your bug report, please add your address to the CC list in there, thanks!

-- 
Maciej Rutecki
http://www.maciek.unixy.pl
