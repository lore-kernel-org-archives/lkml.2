Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681Ab2ABMAd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jan 2012 07:00:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38714 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab2ABMA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jan 2012 07:00:28 -0500
Date: Mon, 2 Jan 2012 12:00:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        "kuninori.morimoto.gx" <kuninori.morimoto.gx@renesas.com>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH v8 3/3 RESEND] ASoC: da7210: Add support for
 line input and mic
Message-ID: <20120102120024.GH2899@opensource.wolfsonmicro.com>
References: <1325505952.12508.12.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1325505952.12508.12.camel@matrix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 02, 2012 at 05:35:52PM +0530, Ashish Chavan wrote:
> DA7210 has three line inputs (AUX1 Left, AUX1 Right and AUX2) and
> a stereo MIC. This patch adds gain controls for MIC, AUX1, AUX2 as
> well as INPGA.

Where are patches 1 and 2?
