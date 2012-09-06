Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2IFOAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:00:52 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:51933 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753769Ab2IFOAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:00:50 -0400
Message-ID: <5048ACAA.3000505@ti.com>
Date: Thu, 06 Sep 2012 17:01:14 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Pantelis Antoniou <panto@antoniou-consulting.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] Don't clobber access methods when !regmap
References: <1346939132-20187-1-git-send-email-panto@antoniou-consulting.com> <50477FA9.8060905@metafoo.de> <D96C7824-5EBC-4418-B016-DCE395A720D7@antoniou-consulting.com>
In-Reply-To: <D96C7824-5EBC-4418-B016-DCE395A720D7@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/05/2012 07:43 PM, Pantelis Antoniou wrote:
> The driver in question (twl4030.c) does not call snd_soc_codec_set_cache_io().
> However the snd-soc core does call it in sound/soc/soc-core.c in soc_probe_codec.
> 
> I do see that there's a commit 98d3088e534a2a61f6690b5426909b0c3b57a785 that is
> fixing it in a different manner.

I also noticed this (with 3.6-rc1 I think).
The commit you mention does fix it so we do not have issue anymore.
I sent two patches related to this:
http://mailman.alsa-project.org/pipermail/alsa-devel/2012-August/053864.html
http://mailman.alsa-project.org/pipermail/alsa-devel/2012-August/053876.html

Mark took a different route which gives us the commit you mentioned:
http://mailman.alsa-project.org/pipermail/alsa-devel/2012-August/053889.html

Regards,
Péter
