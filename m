Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757986Ab1DYBsa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 21:48:30 -0400
Received: from nd215.dnsexit.com ([64.182.102.215]:44048 "EHLO
	box7.911domain.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757865Ab1DYBs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 21:48:28 -0400
X-Complaints-To: abuse@dnsExit.com
X-SPAM: Please report Spam to abuse@dnsExit.com
        By service at http://www.dnsExit.com/Direct.sv?cmd=mailRelay
        Accounts will be suspended immediately if convicted Spam
Message-ID: <4DB4D2C3.4010400@verizon.net>
Date: Sun, 24 Apr 2011 21:47:47 -0400
From: Peter Foley <pefoley2@verizon.net>
Reply-To: <pefoley2@verizon.net>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: <linux-kernel@vger.kernel.org>
CC: <gregkh@suse.de>
Subject: Fwd: Re: [PATCH] staging: solo6x10: add select SND_PCM to fix build
 error
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fowarding to the mailing-list.

-------- Original Message --------
Subject: Re: [PATCH] staging: solo6x10: add select SND_PCM to fix build error
Date: Sun, 24 Apr 2011 20:54:21 -0400
From: Ben Collins <bcollins@bluecherry.net>
To: <pefoley2@verizon.net>

Acked-By: Ben Collins <bcollins@bluecherry.net>

On Apr 24, 2011, at 5:15 PM, Peter Foley wrote:

> This patch fixes a build error when SND_PCM is not set
> by adding a select statment.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>
> ---
> drivers/staging/solo6x10/Kconfig |    1 +
> 1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/solo6x10/Kconfig b/drivers/staging/solo6x10/Kconfig
> index 2cf77c9..03dcac4 100644
> --- a/drivers/staging/solo6x10/Kconfig
> +++ b/drivers/staging/solo6x10/Kconfig
> @@ -2,6 +2,7 @@ config SOLO6X10
> 	tristate "Softlogic 6x10 MPEG codec cards"
> 	depends on PCI && VIDEO_DEV && SND && I2C
> 	select VIDEOBUF_DMA_SG
> +	select SND_PCM
> 	---help---
> 	  This driver supports the Softlogic based MPEG-4 and h.264 codec
> 	  codec cards.
> -- 
> 1.7.5.rc1
> 

Bluecherry: http://www.bluecherrydvr.com/
SwissDisk : http://www.swissdisk.com/
Ubuntu    : http://www.ubuntu.com/
My Blog   : http://ben-collins.blogspot.com/

