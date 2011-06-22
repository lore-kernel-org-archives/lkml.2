Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757603Ab1FVAKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:10:36 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:31102 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752125Ab1FVAKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:10:35 -0400
Message-ID: <4E0132F4.7080506@dsn.okisemi.com>
Date: Wed, 22 Jun 2011 09:10:28 +0900
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alexander Stein <alexander.stein@systec-electronic.com>
CC: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com
Subject: Re: [PATCH v3] pch_gpio: Support interrupt function
References: <1308631468-2376-1-git-send-email-tomoya-linux@dsn.okisemi.com> <201106211110.18171.alexander.stein@systec-electronic.com>
In-Reply-To: <201106211110.18171.alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/21 18:10), Alexander Stein wrote:
> I wrote a small program which use poll(2) on value, after edge hase been
> configured from shell. I cannot test the edge detection appropriately due to
> debouncing using jumpers.
>

Really ?
In out test environment, my test program could detect edge interrupt 
correctly.

-- 
tomoya
OKI SEMICONDUCTOR CO., LTD.
