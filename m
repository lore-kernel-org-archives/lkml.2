Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab1JMQwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:52:18 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42495 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756138Ab1JMQwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:52:16 -0400
Date: Thu, 13 Oct 2011 17:52:15 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Nayak, Rajendra" <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, lrg@ti.com, b-cousson@ti.com, patches@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/5] regulator: map consumer regulator based on device
 tree
Message-ID: <20111013165214.GP5193@opensource.wolfsonmicro.com>
References: <1318263578-7407-1-git-send-email-rnayak@ti.com>
 <1318263578-7407-6-git-send-email-rnayak@ti.com>
 <20111010173506.GH3607@opensource.wolfsonmicro.com>
 <CACYZBRFmLEY_f1UwJa5U9uj8+NVA-WfUVkiuW1yKrpwnrA_00A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACYZBRFmLEY_f1UwJa5U9uj8+NVA-WfUVkiuW1yKrpwnrA_00A@mail.gmail.com>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 12:38:53PM +0530, Nayak, Rajendra wrote:

> How about this updated patch?

Yes, I think that looks broadly sensible.
