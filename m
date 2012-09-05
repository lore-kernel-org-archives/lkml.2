Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886Ab2IEHGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 03:06:52 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39901 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751040Ab2IEHGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 03:06:51 -0400
X-Sasl-enc: ISooOoWjuDthaR5VdPCcMyBO6ItPGQ97HkQFcIbU82mi 1346828810
Message-ID: <5046FA08.4000300@ladisch.de>
Date: Wed, 05 Sep 2012 09:06:48 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>, tiwai@suse.de
CC: perex@perex.cz, yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ALSA: use list_move_tail instead of list_del/list_add_tail
References: <CAPgLHd_1T4S9pngzO=GXthvMD6Ke6xA3t_ZTbvLYRG+TS+2j=w@mail.gmail.com>
In-Reply-To: <CAPgLHd_1T4S9pngzO=GXthvMD6Ke6xA3t_ZTbvLYRG+TS+2j=w@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wei Yongjun wrote:
> Using list_move_tail() instead of list_del() + list_add_tail().
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Clemens Ladisch <clemens@ladisch.de>
