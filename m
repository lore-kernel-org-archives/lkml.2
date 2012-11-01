Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762009Ab2KASCD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:02:03 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3873 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750796Ab2KASCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:02:00 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <5092B900.2090801@broadcom.com>
Date: Thu, 1 Nov 2012 19:01:36 +0100
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028
 Thunderbird/16.0.2
MIME-Version: 1.0
To: "Randy Dunlap" <rdunlap@infradead.org>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, brcm80211-dev-list@broadcom.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH -next] wireless: brcmfmac: fix printk format warning
References: <20121101163622.129b59967d2ee76e6946874a@canb.auug.org.au>
 <5092B4BE.4080803@infradead.org>
In-Reply-To: <5092B4BE.4080803@infradead.org>
X-Enigmail-Version: 1.4.5
X-WSS-ID: 7C8C67113QC3265545-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2012 06:43 PM, Randy Dunlap wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix printk format warning for ssid_len, which is a size_t:
> 
> drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c:3941:2: warning: format '%d' expects type 'int', but argument 4 has type 'size_t'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc:	brcm80211-dev-list@broadcom.com


We actually have a patch ready for that with credit to people who
reported it. We can add you to that list ;-)

Gr. AvS


