Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356Ab1AEIVc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 03:21:32 -0500
Received: from smtp.nokia.com ([147.243.1.47]:26023 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab1AEIVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 03:21:31 -0500
Message-ID: <4D2429F3.80004@nokia.com>
Date: Wed, 05 Jan 2011 10:21:07 +0200
From: Peter Ujfalusi <peter.ujfalusi@nokia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110103 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: "ext tapio.vihuri@nokia.com" <tapio.vihuri@nokia.com>
CC: dmitry.torokhov@gmail.com, randy.dunlap@oracle.com,
        alsa-devel@alsa-project.org, ilkka.koskinen@nokia.com,
        linux-kernel@vger.kernel.org, samu.p.onkalo@nokia.com
Subject: Re: [alsa-devel] [PATCH v3 2/3] ECI: introducing ECI bus driver
References: <1294149748-13854-1-git-send-email-tapio.vihuri@nokia.com>	<1294149748-13854-2-git-send-email-tapio.vihuri@nokia.com> <1294149748-13854-3-git-send-email-tapio.vihuri@nokia.com>
In-Reply-To: <1294149748-13854-3-git-send-email-tapio.vihuri@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 01/04/11 16:02, ext tapio.vihuri@nokia.com wrote:
> From: Tapio Vihuri <tapio.vihuri@nokia.com>
> 
> ECI bus controller is kind of bridge between host CPU I2C and ECI accessory
> ECI communication.

There seams to be no change between v2 and v3 in regards to this micro
controller driver, so my comments on the v2 applies here as well.

Would you rename the driver (to something other than ecibus)?
If the intention is to make this driver only work on Intel's Moorestown
platform, then be it, but you should mention it explicitly in the
Kconfig, and the driver name shall reflect the same as well.

My comments on the intel specific intel_scu_ipc_iowrite8, and the i2c
part still holds.

Thanks,
Péter
