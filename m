Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756914Ab0D0VJw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 17:09:52 -0400
Received: from kroah.org ([198.145.64.141]:49354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756842Ab0D0VJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 17:09:49 -0400
Date: Tue, 27 Apr 2010 14:00:29 -0700
From: Greg KH <greg@kroah.com>
To: Gorskin Ilya <revent82@gmail.com>
Cc: gregkh@suse.de, hsweeten@visionengravers.com, ss@aao.gov.au,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging:dt3155: fix coding style issue in
 dt3155_drv.c This is a patch to the dt3155_drv.c file that fixes up a
 coding style warning and errors found by the checkpatch.pl tool;
Message-ID: <20100427210029.GB5046@kroah.com>
References: <1268469277-29388-1-git-send-email-revent82@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268469277-29388-1-git-send-email-revent82@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 01:34:37PM +0500, Gorskin Ilya wrote:
> @@ -183,241 +183,215 @@ static inline void dt3155_isr( int irq, void *dev_id, struct pt_regs *regs )
>    u32 buffer_addr;
>  
>    /* find out who issued the interrupt */
> -  for ( index = 0; index < ndevices; index++ ) {
> -    if( dev_id == (void*) &dt3155_status[ index ])
> -      {
> -	minor = index;
> +    for (index = 0; index < ndevices; index++) {
> +	if (dev_id == (void *) &dt3155_status[index]) {
> +		minor = index;

This fixes up the {} usage, but not the tabs/spaces issues, so it is
still incorrect.  Can you fix that up at the same time here?

thanks,

greg k-h
