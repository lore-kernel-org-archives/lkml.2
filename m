Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753387Ab2H3JTM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 05:19:12 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:58711 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab2H3JTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 05:19:10 -0400
Message-ID: <503F301A.1090200@ti.com>
Date: Thu, 30 Aug 2012 12:19:22 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: t-kristo@ti.com
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, alsa-devel@alsa-project.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, Benoit Cousson <b-cousson@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 02/14] MFD: twl4030-audio: Convert to use devm_kzalloc
References: <1344954162-7985-1-git-send-email-peter.ujfalusi@ti.com>  <1344954162-7985-3-git-send-email-peter.ujfalusi@ti.com> <1346147410.2182.96.camel@sokoban>
In-Reply-To: <1346147410.2182.96.camel@sokoban>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tero,

On 08/28/2012 12:50 PM, Tero Kristo wrote:
> On Tue, 2012-08-14 at 17:22 +0300, Peter Ujfalusi wrote:
>> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> 
> I think this one could use a short commit message, also about why
> kfree():s are dropped (handled internally by devm_* etc.)

I don't like empty commit messages either but this patch is self explaining I
would think that the commit title explains it.

-- 
Péter
