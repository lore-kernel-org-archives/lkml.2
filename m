Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab1KGXHi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 18:07:38 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:55876 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403Ab1KGXHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 18:07:37 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH] PM/devfreq: fix private_data
Date: Tue, 8 Nov 2011 00:10:13 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
References: <20111107155223.702240b0@dt.lwn.net>
In-Reply-To: <20111107155223.702240b0@dt.lwn.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111080010.13882.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 07, 2011, Jonathan Corbet wrote:
> The "private_date" field in struct devfreq_dev_status almost certainly
> wants to be "private_data"; since there are no in-tree users of this
> functionality, now seems like an easy time to make the fix.
> 
> Signed-off-by: Jonathan Corbet <corbet@lwn.net>

Thanks for the fix, applied to linux-pm/linux-next and will be pushed to
Linus around tomorrow.

Thanks,
Rafael


> diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
> index afb9458..98ce812 100644
> --- a/include/linux/devfreq.h
> +++ b/include/linux/devfreq.h
> @@ -41,7 +41,7 @@ struct devfreq_dev_status {
>  	unsigned long total_time;
>  	unsigned long busy_time;
>  	unsigned long current_frequency;
> -	void *private_date;
> +	void *private_data;
>  };
>  
>  /**
> 
> 

