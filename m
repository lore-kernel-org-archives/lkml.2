Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab1HQNmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 09:42:47 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2936 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1HQNmn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 09:42:43 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Subject: Re: [PATCH V2 net-next 3/3] bnx2x: Use pr_fmt and message
 logging cleanups
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Joe Perches" <joe@perches.com>
cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <2d33739418a06602c817d002b30fedd57cbe5f11.1313360101.git.joe@perches.com>
References: <cover.1313360100.git.joe@perches.com>
 <2d33739418a06602c817d002b30fedd57cbe5f11.1313360101.git.joe@perches.com>
Organization: Broadcom
Date: Wed, 17 Aug 2011 16:42:28 +0300
Message-ID: <1313588549.7266.9.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 625519093KO6809951-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-08-14 at 15:16 -0700, Joe Perches wrote:
> Add pr_fmt(fmt) KBUILD_MODNAME ": " to prefix messages with "bnx2x: ".
> Remove #define DP_LEVEL and use pr_notice.
> Repeating KERN_<LEVEL> isn't necessary in multi-line printks.
> printk macro neatening, use fmt and ##__VA_ARGS__.
> Coalesce long formats.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
Acked-by: Eilon Greenstein <eilong@broadcom.com>


