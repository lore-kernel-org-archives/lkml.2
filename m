Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab2HaVYm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 17:24:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53402 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752509Ab2HaVYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 17:24:41 -0400
Date: Fri, 31 Aug 2012 14:24:36 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Prasad Joshi <prasadjoshi.linux@gmail.com>
Cc: lrg@ti.com, perex@perex.cz, tiwai@suse.de, rajeev-dlh.kumar@st.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: correct the check for NULL dma_buffer pointer
Message-ID: <20120831212435.GB5495@opensource.wolfsonmicro.com>
References: <1346383521-2990-1-git-send-email-prasadjoshi.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346383521-2990-1-git-send-email-prasadjoshi.linux@gmail.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 08:55:21AM +0530, Prasad Joshi wrote:
> The if condition
> 	if (!buf && !buf->area)
> 
> checks if the buf pointer is NULL and then dereferences it again to
> check if the buffer area is NULL, resulting in possible NULL
> dereference.

Applied, thanks.
