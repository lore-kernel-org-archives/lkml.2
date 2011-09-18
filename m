Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070Ab1IRLAp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 07:00:45 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:39513 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750923Ab1IRLAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 07:00:44 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtIFAKfNdU5XQAOS/2dsb2JhbABBpUmBfXiBUwEBBScRHiIBEAsYCRYPCQMCAQIBJx4GDQEHAQGHdbUJhngEmGaMEg
Message-ID: <4E75CF46.6050706@computer.org>
Date: Sun, 18 Sep 2011 13:00:22 +0200
From: Jan Ceuleers <jan.ceuleers@computer.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Kelly Anderson <kelly@silka.with-linux.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: fix regulaotry misspelling in net/wireless/reg.c
References: <4E750964.8060502@silka.with-linux.com>
In-Reply-To: <4E750964.8060502@silka.with-linux.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/2011 10:56 PM, Kelly Anderson wrote:
> --- ./net/wireless/reg.c.orig    2011-08-29 14:56:30.000000000 -0600
> +++ ./net/wireless/reg.c    2011-09-17 14:42:38.305715253 -0600
> @@ -903,7 +903,7 @@ static bool ignore_reg_update(struct wip
>          initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
>          !is_world_regdom(last_request->alpha2)) {
>          REG_DBG_PRINT("Ignoring regulatory request %s "
> -                  "since the driver requires its own regulaotry "
> +                  "since the driver requires its own regulatory "
>                    "domain to be set first",
>                    reg_initiator_name(initiator));
>          return true; 

This typo exists neither in Linus's linux tree, nor in davem's net and 
net-next trees.

Furthermore, your patch was whitespace-damaged.
