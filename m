Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2FOHuz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 03:50:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:31298 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab2FOHux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 03:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="180385916"
Date: Fri, 15 Jun 2012 10:50:50 +0300
From: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>
To: Masatake YAMATO <yamato@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH 5/8] Added /proc/net/hidp via bt_procfs_init()
Message-ID: <20120615075049.GB7205@aemeltch-MOBL1>
Mail-Followup-To: Andrei Emeltchenko <andrei.emeltchenko.news@gmail.com>,
	Masatake YAMATO <yamato@redhat.com>, linux-kernel@vger.kernel.org,
	linux-bluetooth@vger.kernel.org
References: <20120615.021742.1385079555521232550.yamato@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615.021742.1385079555521232550.yamato@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masatake,

On Fri, Jun 15, 2012 at 02:17:42AM +0900, Masatake YAMATO wrote:
> Added /proc/net/hidp via bt_procfs_init().
> 
> Signed-off-by: Masatake YAMATO <yamato@redhat.com>
> ---
>  net/bluetooth/hidp/sock.c |   24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/net/bluetooth/hidp/sock.c b/net/bluetooth/hidp/sock.c
> index 73a32d7..dd31d8f 100644
> --- a/net/bluetooth/hidp/sock.c
> +++ b/net/bluetooth/hidp/sock.c
> @@ -39,6 +39,11 @@
>  
>  #include "hidp.h"
>  
> +

Extra space here

Best regards 
Andrei Emeltchenko 


