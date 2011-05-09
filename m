Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1EIHNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 03:13:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:48460 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752813Ab1EIHNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 03:13:36 -0400
Date: Mon, 9 May 2011 09:13:42 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 12/19] mfd: Use mfd cell platform_data for wm8400 cells
 platform bits
Message-ID: <20110509071341.GA21967@opensource.wolfsonmicro.com>
References: <1304901131-7104-1-git-send-email-sameo@linux.intel.com>
 <1304901131-7104-13-git-send-email-sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1304901131-7104-13-git-send-email-sameo@linux.intel.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 02:32:04AM +0200, Samuel Ortiz wrote:

>  static int wm8400_codec_probe(struct snd_soc_codec *codec)
>  {
> -	struct wm8400 *wm8400 = mfd_get_data(to_platform_device(codec->dev));
> +	struct wm8400 *wm8400 = codec->dev->platform_data;

It'd be better to use platform_get_drvdata() here rather than accessing
the pointer directly.
