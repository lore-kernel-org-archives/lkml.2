Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479Ab2E3UvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 16:51:01 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:4171 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2E3Uu7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 16:50:59 -0400
X-Server-Uuid: 72204117-5C29-4314-8910-60DB108979CB
Message-ID: <4FC68821.4010507@broadcom.com>
Date: Wed, 30 May 2012 22:50:41 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Joe Perches" <joe@perches.com>
cc: linux-kernel@vger.kernel.org, "Brett Rudley" <brudley@broadcom.com>,
        "Roland Vossen" <rvossen@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        "Kan Yan" <kanyan@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 3/4] brcmfmac: Fix likely misuse of | for &
References: <cover.1338408931.git.joe@perches.com>
 <af79247f427979584f3e07753ec3ad4766844ec9.1338408931.git.joe@perches.com>
In-Reply-To: <af79247f427979584f3e07753ec3ad4766844ec9.1338408931.git.joe@perches.com>
X-Enigmail-Version: 1.5pre
X-WSS-ID: 63D857D255G3565557-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2012 10:25 PM, Joe Perches wrote:
> Using | with a constant is always true.
> Likely this should have be &.

Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/brcm80211/brcmfmac/bcmsdh.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)



