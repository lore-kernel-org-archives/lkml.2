Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755990Ab3AGWjr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:39:47 -0500
Received: from mail-da0-f52.google.com ([209.85.210.52]:49447 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab3AGWjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:39:46 -0500
Date: Mon, 7 Jan 2013 14:39:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Lijo Antony <lijo.kernel@gmail.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: comedi: addi_common.h: checkpatch.pl fixes
Message-ID: <20130107223941.GA3913@kroah.com>
References: <1357395175-6077-1-git-send-email-lijo.kernel@gmail.com>
 <1357395175-6077-2-git-send-email-lijo.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357395175-6077-2-git-send-email-lijo.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 06:12:55PM +0400, Lijo Antony wrote:
> Reduced line lengths to 80 chars by removing extra spaces.
> 
> Signed-off-by: Lijo Antony <lijo.kernel@gmail.com>
> ---
>  .../staging/comedi/drivers/addi-data/addi_common.h |   20 ++++++++++----------
>  1 file changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h b/drivers/staging/comedi/drivers/addi-data/addi_common.h
> index 6d8b29f94..1996a68 100644
> --- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
> +++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
> @@ -298,7 +298,7 @@ struct addi_private {
>  	unsigned char b_AiInitialisation;
>  	unsigned int ui_AiActualScan;	/* how many scans we finished */
>  	unsigned int ui_AiBufferPtr;	/*  data buffer ptr in samples */
> -	unsigned int ui_AiNbrofChannels;	/*  how many channels is measured */
> +	unsigned int ui_AiNbrofChannels; /*  how many channels is measured */
>  	unsigned int ui_AiScanLength;	/*  Length of actual scanlist */
>  	unsigned int ui_AiActualScanPosition;	/*  position in actual scan */
>  	unsigned int *pui_AiChannelList;	/*  actual chanlist */
> @@ -313,14 +313,14 @@ struct addi_private {
>  	short *AiData;	/*  Pointer to sample data */
>  	unsigned int ui_AiNbrofScans;	/*  number of scans to do */
>  	unsigned short us_UseDma;	/*  To use Dma or not */
> -	unsigned char b_DmaDoubleBuffer;	/*  we can use double buffering */
> +	unsigned char b_DmaDoubleBuffer; /*  we can use double buffering */
>  	unsigned int ui_DmaActualBuffer;	/*  which buffer is used now */
>  	/* UPDATE-0.7.57->0.7.68 */
>  	/* unsigned int               ul_DmaBufferVirtual[2]; pointers to begin of DMA buffer */
>  	short *ul_DmaBufferVirtual[2];	/*  pointers to begin of DMA buffer */
>  	unsigned int ul_DmaBufferHw[2];	/*  hw address of DMA buff */
> -	unsigned int ui_DmaBufferSize[2];	/*  size of dma buffer in bytes */
> -	unsigned int ui_DmaBufferUsesize[2];	/*  which size we may now used for transfer */
> +	unsigned int ui_DmaBufferSize[2]; /*  size of dma buffer in bytes */
> +	unsigned int ui_DmaBufferUsesize[2]; /* size we may use for transfer */
>  	unsigned int ui_DmaBufferSamples[2];	/*  size in samples */
>  	unsigned int ui_DmaBufferPages[2];	/*  number of pages in buffer */
>  	unsigned char b_DigitalOutputRegister;	/*  Digital Output Register */
> @@ -331,13 +331,13 @@ struct addi_private {
>  	unsigned char b_ModeSelectRegister;	/*  Contain data written at iobase + 0E */
>  	unsigned short us_OutputRegister;	/*  Contain data written at iobase + 0 */
>  	unsigned char b_InterruptState;
> -	unsigned char b_TimerInit;	/*  Specify if InitTimerWatchdog was load */
> -	unsigned char b_TimerStarted;	/*  Specify if timer 2 is running or not */
> +	unsigned char b_TimerInit; /*  Specify if InitTimerWatchdog was load */

As you didn't do this for all fields in the structure, it's not really
worth doing it for just these, right?

The proper thing to do is use kerneldoc format and document it all at
the top of the structure, care to do that instead?

thanks,

greg k-h
