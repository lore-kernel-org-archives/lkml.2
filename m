Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752492Ab1IEKoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:44:02 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:38191 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751871Ab1IEKn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:43:57 -0400
From: =?ISO-8859-1?Q?P=E9ter?= Ujfalusi <peter.ujfalusi@ti.com>
To: Thomas Weber <weber@corscience.de>
Cc: linux-kernel@vger.kernel.org, sameo@linux.intel.com,
        linux-omap@vger.kernel.org, broonie@opensource.wolfsonicro.com,
        tiwai@suse.de, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC/MFD: twl4030: Fix dependencies for audio codec
Date: Mon, 05 Sep 2011 13:43:51 +0300
Message-ID: <1904434.zs3M0Tebna@barack>
User-Agent: KMail/4.7.0  (Linux/3.0.3-gentoo; KDE/4.7.0; x86_64; ; )
In-Reply-To: <1315214793-661-1-git-send-email-weber@corscience.de>
References: <1315214793-661-1-git-send-email-weber@corscience.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 September 2011 11:26:33 Thomas Weber wrote:
> The codec for Devkit8000 (TWL4030)  was not detected except
> when build with CONFIG_SND_SOC_ALL_CODECS.
> 
> twl-core.c still uses the CONFIG_TWL4030_CODEC for
> twl_has_codec().

acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
