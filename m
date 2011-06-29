Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab1F2K0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:26:24 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:17610 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247Ab1F2K0W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:26:22 -0400
Message-ID: <4E0AFDCA.3050908@dsn.okisemi.com>
Date: Wed, 29 Jun 2011 19:26:18 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: "Wang, Yong Y" <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com> <201106271622.52763.alexander.stein@systec-electronic.com> <4E09AE3A.8050306@dsn.okisemi.com> <201106290828.06508.alexander.stein@systec-electronic.com>
In-Reply-To: <201106290828.06508.alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/29 15:28), Alexander Stein wrote:
> Are you sure you applied the patch? There shouldn't be a _raw_spin_lock_bh
> here.
> 

You are right.
I tested again, as a result,
I could confirm that after using your patch,
kernel error message doesn't logged at all.
It seems my patching yesterday was failed or operation mistake.
Sorry for the in inconvenience.

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
