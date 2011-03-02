Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606Ab1CBOHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:07:35 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2449 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751138Ab1CBOHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:07:34 -0500
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4D6E4F18.4060505@broadcom.com>
Date: Wed, 2 Mar 2011 15:07:20 +0100
From: "Roland Vossen" <rvossen@broadcom.com>
Organization: Broadcom
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13)
 Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Randy Dunlap" <randy.dunlap@oracle.com>
cc: "Stephen Rothwell" <sfr@canb.auug.org.au>,
        "gregkh@suse.de" <gregkh@suse.de>,
        driverdevel <devel@driverdev.osuosl.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Arend Van Spriel" <arend@broadcom.com>
Subject: Re: [PATCH -next] staging/brcm80211: fix printk format warnings
References: <20110301181119.f1c7a9c3.sfr@canb.auug.org.au>
 <20110301162948.34c28d6e.randy.dunlap@oracle.com>
In-Reply-To: <20110301162948.34c28d6e.randy.dunlap@oracle.com>
X-WSS-ID: 6170902D68G244196-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c:1379: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> drivers/staging/brcm80211/sys/wl_mac80211.c:1827: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
> drivers/staging/brcm80211/sys/wl_mac80211.c:1832: warning: format '%d' expects type 'int', but argument 3 has type 'size_t'
>
> Signed-off-by: Randy Dunlap<randy.dunlap@oracle.com>

Acked-by: Roland Vossen<rvossen@broadcom.com>

Thanks Randy.

