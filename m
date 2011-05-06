Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756720Ab1EFQ4m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 12:56:42 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:55791 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756653Ab1EFQ4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 12:56:41 -0400
Message-ID: <4DC42841.9040103@atmel.com>
Date: Fri, 06 May 2011 18:56:33 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: vinod.koul@intel.com
CC: dan.j.williams@intel.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] dmaengine: at_hdmac: implement pause and resume
 in atc_control
References: <f4341d4672a23a958398b75cb4305e0e680f2e32.1304532833.git.nicolas.ferre@atmel.com> <be7d19459501aaa604aebe91daa9e9e59bb41c86.1304704588.git.nicolas.ferre@atmel.com>
In-Reply-To: <be7d19459501aaa604aebe91daa9e9e59bb41c86.1304704588.git.nicolas.ferre@atmel.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 06/05/2011 19:56, Nicolas Ferre :
> Pause and resume controls are useful for audio devices. This also returns
> correct status from atc_tx_status() in case chan is paused.
> 
> Idea from dw_dmac patch by Linus Walleij.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---

V2: In case of pause, some peripheral are not draining data out of FIFO
    if they are stopped or not clocked: we need to find a way out with
    a simple timeout.

[..]

Best regards,
-- 
Nicolas Ferre

