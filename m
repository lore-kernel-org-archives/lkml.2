Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964896Ab2JSQA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 12:00:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39367 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964851Ab2JSQA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 12:00:26 -0400
Message-ID: <50817916.2060409@wwwdotorg.org>
Date: Fri, 19 Oct 2012 10:00:22 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Alexandre Courbot <acourbot@nvidia.com>, linux-fbdev@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>, linux-pm@vger.kernel.org,
        Leela Krishna Amudala <l.krishna@samsung.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Anton Vorontsov <cbou@mail.ru>,
        linux-tegra@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v7 2/3] pwm_backlight: use power sequences
References: <1350637589-7405-1-git-send-email-acourbot@nvidia.com> <1350637589-7405-3-git-send-email-acourbot@nvidia.com> <1350638436.3339.2.camel@gitbox>
In-Reply-To: <1350638436.3339.2.camel@gitbox>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 03:20 AM, Tony Prisk wrote:
> On Fri, 2012-10-19 at 18:06 +0900, Alexandre Courbot wrote:
>> Make use of the power sequences specified in the device tree or platform
>> data to control how the backlight is powered on and off.

Tony, please do cut down the amount of the patch that you quote. If you
don't, it's impossible to find your comments. Thanks.
