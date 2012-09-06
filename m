Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2IFOCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 10:02:52 -0400
Received: from li42-95.members.linode.com ([209.123.162.95]:58132 "EHLO
	li42-95.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751020Ab2IFOCv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 10:02:51 -0400
Subject: Re: [PATCH] Don't clobber access methods when !regmap
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <5048ACAA.3000505@ti.com>
Date: Thu, 6 Sep 2012 17:02:46 +0300
Cc: Lars-Peter Clausen <lars@metafoo.de>, linux-kernel@vger.kernel.org,
        patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-omap@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <1C46E0E7-6D8F-4FD7-B9BC-40C322D423C8@antoniou-consulting.com>
References: <1346939132-20187-1-git-send-email-panto@antoniou-consulting.com> <50477FA9.8060905@metafoo.de> <D96C7824-5EBC-4418-B016-DCE395A720D7@antoniou-consulting.com> <5048ACAA.3000505@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sep 6, 2012, at 5:01 PM, Peter Ujfalusi wrote:

> Hi,
> 
> On 09/05/2012 07:43 PM, Pantelis Antoniou wrote:
>> The driver in question (twl4030.c) does not call snd_soc_codec_set_cache_io().
>> However the snd-soc core does call it in sound/soc/soc-core.c in soc_probe_codec.
>> 
>> I do see that there's a commit 98d3088e534a2a61f6690b5426909b0c3b57a785 that is
>> fixing it in a different manner.
> 
> I also noticed this (with 3.6-rc1 I think).
> The commit you mention does fix it so we do not have issue anymore.
> I sent two patches related to this:
> http://mailman.alsa-project.org/pipermail/alsa-devel/2012-August/053864.html
> http://mailman.alsa-project.org/pipermail/alsa-devel/2012-August/053876.html
> 
> Mark took a different route which gives us the commit you mentioned:
> http://mailman.alsa-project.org/pipermail/alsa-devel/2012-August/053889.html
> 
> Regards,
> Péter

Quite similar to my patches. They're not needed now, since I have verified that
the issue is fixed.

Regards

-- Pantelis

