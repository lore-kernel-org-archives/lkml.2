Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab2KIVd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:33:57 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38891 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab2KIVdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:33:54 -0500
Message-ID: <509D76BF.6030808@wwwdotorg.org>
Date: Fri, 09 Nov 2012 14:33:51 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: tegra: harmony: Add ADT7641 temperature sensor
References: <1352465815-26984-1-git-send-email-thierry.reding@avionic-design.de> <20121109132257.GA29183@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20121109132257.GA29183@avionic-0098.mockup.avionic-design.de>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09/2012 06:22 AM, Thierry Reding wrote:
> On Fri, Nov 09, 2012 at 01:56:55PM +0100, Thierry Reding wrote:
>> The Harmony board has an Analog Devices ADT7461 temperature
>> sensor connected to the DVC bus. It can be used to monitor the
>> ambient (local) and on-die (remote) temperatures.
> 
> Note that I haven't actually tested this, as I no longer have
> access to Harmony hardware. Testing can easily be done either by
> reading the files from sysfs directly or by running the sensors
> utility from the lm-sensors package.

Tested-by: Stephen Warren <swarren@nvidia.com>

Ventana also has the same sensor and due to git am applying your patch
to the wrong file (I've renamed all my .dts files), I ended up testing
that too, so you may as well send a second patch for Ventana. Ventana
has an nct1008 though.
