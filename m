Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab2HLEuH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 00:50:07 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:1115 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750711Ab2HLEuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 00:50:02 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <50273628.50503@broadcom.com>
Date: Sun, 12 Aug 2012 07:50:48 +0300
From: "Yuval Mintz" <yuvalmin@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:13.0)
 Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Joren Van Onder" <joren.vanonder@gmail.com>
cc: eilong@broadcom.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: Fix compiler warnings
References: <1344741035-1493-1-git-send-email-joren.vanonder@gmail.com>
In-Reply-To: <1344741035-1493-1-git-send-email-joren.vanonder@gmail.com>
X-WSS-ID: 7C39EA153NK14433589-01-01
Content-Type: text/plain;
 charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Fix the following compiler warnings:
> 
>  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:2908:3: warning: comparison
>    of distinct pointer types lacks a cast [enabled by default]
>  - drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c:1709:7: warning: comparison
>    of distinct pointer types lacks a cast [enabled by default]
> 
> Signed-off-by: Joren Van Onder <joren.vanonder@gmail.com>
Thanks Joren.
Acked-By: Yuval Mintz <yuvalmin@broadcom.com>



