Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab2ILWPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 18:15:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:44416 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753673Ab2ILWPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 18:15:37 -0400
Message-ID: <50510985.40308@wwwdotorg.org>
Date: Wed, 12 Sep 2012 16:15:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Simon Glass <sjg@chromium.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Anton Vorontsov <cbou@mail.ru>, David Woodhouse <dwmw2@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-pm@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v6 2/4] pwm_backlight: use power sequences
References: <1347443867-18868-1-git-send-email-acourbot@nvidia.com> <1347443867-18868-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1347443867-18868-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 03:57 AM, Alexandre Courbot wrote:
> Make use of the power sequences specified in the device tree or platform
> data to control how the backlight is powered on and off.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>

Reviewed-by: Stephen Warren <swarren@wwwdotorg.org>

