Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754400Ab0IMNXs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 09:23:48 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.31]:56992 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353Ab0IMNXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 09:23:47 -0400
Message-ID: <4C8E25ED.3090803@ladisch.de>
Date: Mon, 13 Sep 2010 15:23:57 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH 3,5,7/8] sound/* Update broken web addresses.
References: <1284222928-4150-1-git-send-email-justinmattock@gmail.com> <1284222928-4150-7-git-send-email-justinmattock@gmail.com>
In-Reply-To: <1284222928-4150-7-git-send-email-justinmattock@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin P. Mattock wrote:
> --- a/sound/oss/ac97_codec.c
> +++ b/sound/oss/ac97_codec.c
>   * The Intel Audio Codec '97 specification is available at the Intel
 >- * audio homepage: http://developer.intel.com/ial/scalableplatforms/audio/
> + * audio homepage: http://developer.intel.com/

drop this link

>   * The specification itself is currently available at:
> - * ftp://download.intel.com/ial/scalableplatforms/ac97r22.pdf
> + * ftp://ftp.intel.com/pub/ 

http://download.intel.com/support/motherboards/desktop/sb/ac97_r23.pdf

> --- a/sound/pci/ens1370.c
> +++ b/sound/pci/ens1370.c
> - * using http://www.alsa-project.org/~iwai/writing-an-alsa-driver/c1540.htm
> + * using http://www.alsa-project.org/~iwai/

http://www.kernel.org/pub/linux/kernel/people/tiwai/docs/writing-an-alsa-driver/index.html

> --- a/sound/pci/intel8x0.c
> +++ b/sound/pci/intel8x0.c
> - *	http://www.intel.com/design/chipsets/specupdt/245051.htm
> + *	http://www.intel.com/p/en_US/business/design	

http://download.intel.com/design/chipsets/specupdt/24505108.pdf
