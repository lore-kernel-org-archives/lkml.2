Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932197Ab2CBNxr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 08:53:47 -0500
Received: from nbd.name ([46.4.11.11]:52672 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab2CBNxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 08:53:46 -0500
Message-ID: <4F50D0CD.1060100@openwrt.org>
Date: Fri, 02 Mar 2012 14:53:17 +0100
From: John Crispin <blogic@openwrt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.20) Gecko/20110820 Icedove/3.1.12
MIME-Version: 1.0
To: Danny Kukawka <danny.kukawka@bisect.de>
CC: "David S. Miller" <davem@davemloft.net>, Danny Kukawka <dkukawka@suse.de>,
        Joe Perches <joe@perches.com>, Ralf Baechle <ralf@linux-mips.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] lantiq_etop: use dev_set_mac_address() instead of
 ltq_etop_set_mac_address()
References: <1330620747-4047-1-git-send-email-danny.kukawka@bisect.de> <1330620747-4047-6-git-send-email-danny.kukawka@bisect.de>
In-Reply-To: <1330620747-4047-6-git-send-email-danny.kukawka@bisect.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/12 17:52, Danny Kukawka wrote:
> Use dev_set_mac_address() instead of ltq_etop_set_mac_address() directly
> to get validation checks for free.
>
> Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
Acked-by: John Crispin <blogic@openwrt.org>
