Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387Ab1FXF2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 01:28:17 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:1872 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750773Ab1FXF2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 01:28:16 -0400
Message-ID: <4E04206C.5000008@dsn.okisemi.com>
Date: Fri, 24 Jun 2011 14:28:12 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: "Wang, Yong Y" <yong.y.wang@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        "Wang, Qi" <qi.wang@intel.com>,
        "toshiharu-linux@dsn.okisemi.com" <toshiharu-linux@dsn.okisemi.com>
Subject: Re: [PATCH] pch_dma: Fix channel locking
References: <1308755133-8605-1-git-send-email-alexander.stein@systec-electronic.com> <4E0284C7.30909@dsn.okisemi.com> <201106230942.24105.alexander.stein@systec-electronic.com>
In-Reply-To: <201106230942.24105.alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexander Stein

I couldn't see the issue at all.

(2011/06/23 16:42), Alexander Stein wrote:
> The close and open is actually needed (I had a separate application for that
> yesterday).
Does the above mean that we must delete "close" processing from your
test program, right ?
(Modifying like this, I couldn't see the issue)
> 
> If all is done without closing again, I get the following bug:
> 
Does the above mean that executing your test program many times whose 2
"close" are deleted , did you see the issue ?

My steps like below
Boot Fedora14
Install DMA driver
Install pch_uart driver
Enable DMA (setserial /dev/ttyPCH0 ^low_latency)
Modifying your test program
  Delete 2 close() function.
Compile your test program.
Execute the tp.
Execute the tp.
Execute the tp.
I couldn't see any error message.

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
