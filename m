Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab1LBXa6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 18:30:58 -0500
Received: from mga14.intel.com ([143.182.124.37]:11685 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751248Ab1LBXa4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 18:30:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,286,1320652800"; 
   d="scan'208";a="43446201"
Date: Fri, 2 Dec 2011 23:42:48 +0000
From: Alan Cox <alan@linux.intel.com>
To: Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serial/documentation: fix name of DCD cpp symbol
Message-ID: <20111202234248.373cfd4f@bob.linux.org.uk>
In-Reply-To: <1322857211-26654-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1322857211-26654-1-git-send-email-u.kleine-koenig@pengutronix.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Dec 2011 21:20:11 +0100
Uwe Kleine-König <u.kleine-koenig@pengutronix.de> wrote:

> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  Documentation/serial/driver |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/serial/driver b/Documentation/serial/driver
> index 77ba0af..0a25a91 100644
> --- a/Documentation/serial/driver
> +++ b/Documentation/serial/driver
> @@ -101,7 +101,7 @@ hardware.
>  	Returns the current state of modem control inputs.  The state
>  	of the outputs should not be returned, since the core keeps
>  	track of their state.  The state information should include:
> -		- TIOCM_DCD	state of DCD signal
> +		- TIOCM_CAR	state of DCD signal
>  		- TIOCM_CTS	state of CTS signal
>  		- TIOCM_DSR	state of DSR signal
>  		- TIOCM_RI	state of RI signal

Acked-by: Alan Cox <alan@linux.intel.com>

but please fix the Subject line to be less confusing - it sounds like
it changes the define not the docs... 
