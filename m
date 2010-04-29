Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756673Ab0D2BsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 21:48:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32425 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751798Ab0D2BsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 21:48:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5966"; a="39950069"
Subject: Re: [PATCH] arm/mach-msm: Fix wrong include path.
From: Daniel Walker <dwalker@codeaurora.org>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: David Brown <davidb@codeaurora.org>,
       Bryan Huntsman <bryanh@codeaurora.org>,
       Russell King <linux@arm.linux.org.uk>, San Mehat <san@google.com>,
       Dima Zavin <dima@android.com>, linux-arm-msm@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <201004290229.53378.PeterHuewe@gmx.de>
References: <201004290229.53378.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Apr 2010 18:48:04 -0700
Message-ID: <1272505684.2007.128.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-04-29 at 02:29 +0200, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This patch fixes a build failure[1] caused by a wrong include path.
> 
> References:
> [1] http://kisskb.ellerman.id.au/kisskb/buildresult/2535826/
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Oddly, I just fixed this like 4 hours ago ..

Daniel

