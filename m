Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753954Ab1GNIBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 04:01:35 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53334 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753834Ab1GNIBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 04:01:33 -0400
Date: Thu, 14 Jul 2011 10:59:50 +0300
From: Dan Carpenter <error27@gmail.com>
To: Ravishankar <ravishankarkm32@gmail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Ravishankar <ravi.shankar@greenturtles.in>
Subject: Re: [PATCH 1/3] Staging: comedi: fix warning issue in daqboard2000.c
Message-ID: <20110714075950.GS18655@shale.localdomain>
References: <1310623333-16176-1-git-send-email-ravishankarkm32@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310623333-16176-1-git-send-email-ravishankarkm32@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 11:32:13AM +0530, Ravishankar wrote:
>     2. The initialization done so far is:
> -        a. program the FPGA (windows code sans a lot of error messages)
> +	a.program the FPGA(windows code sans a lot of error messages)
          ^
Space needed here.


>  
> -        Word0:
> -          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> -          ! | | | ! | | | ! | | | ! | | | !
> -          +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> +	Word0:
> +	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
> +	  !|||!|||!|||!|||!
> +	  +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

No.  The original comment is a diagram and you have destroyed it
completely.

You are writing all these patches to do the minimum needed to make
check patch happy.  Check patch is not a human being.  Do not write
code to please check patch, because it feels no sadness or happiness.

You have made yourself into a servant of a shell script.  Have some
dignity.

regards,
dan carpenter
