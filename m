Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1HJUyp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 16:54:45 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41768 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754127Ab1HJUyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 16:54:43 -0400
Message-ID: <4E42F015.1090801@linaro.org>
Date: Wed, 10 Aug 2011 22:54:45 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110516 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        gregkh@suse.de, linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH v2 2/2] cpu: update cpu_hotpluggable_mask in register_cpu
References: <1313006614-28702-1-git-send-email-mturquette@ti.com> <1313006614-28702-3-git-send-email-mturquette@ti.com>
In-Reply-To: <1313006614-28702-3-git-send-email-mturquette@ti.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 08/10/2011 10:03 PM, Mike Turquette wrote:
> Update the cpu_hotpluggable_mask for each registered CPU which supports
> hotplug.  This makes it trivial for kernel code to know which CPUs
> support hotplug operations.
> 
> Signed-off-by: Mike Turquette <mturquette@ti.com>

Reviewed-by: <Daniel Lezcano> daniel.lezcano@linaro.org

- -- 
 <http://www.linaro.org/> Linaro.org ? Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOQvAUAAoJEAKBbMCpUGYADTYH/3jGeK5pryiVKaxQ7wUBwsG6
7ugSLCCgBVUL6ueuVmlphhfW8Vv9Uz72LlJnaJUmJ0deK/Rf5x1ccFulBTtIsyjK
Zbw4Wg0MYxfNo0OAi7OSjWMUw31PC8kKVBSUZd3zHeqi6TanKUtxR5im4EWGhQbc
+Njhx2jAqZBEEcPnODiRx+CbYJX17N2Cesmk8Z+Tk00LIpM30iGGX15ZWXnV6KWM
zD3vG7ATLa/rv1/xPa67SDXdZIo99wDodjtjTFPClygM/XTSNBiIxsm9LnnUkmyw
gw1Q6Ng+wo2XyhxJ//b+kM0natnc7Tl6RtDIL7T+j9rIAdf8Sz9DPgmafWQRxYY=
=hwkF
-----END PGP SIGNATURE-----
