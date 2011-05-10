Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab1EJL7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 07:59:31 -0400
Received: from mailrelay010.isp.belgacom.be ([195.238.6.177]:62166 "EHLO
	mailrelay010.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754434Ab1EJL73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 07:59:29 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAGwnyU1R8iw3/2dsb2JhbAClfXjFWw6GAQSeUA
Date: Tue, 10 May 2011 13:14:00 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>,
        David Dajun Chen <Dajun.Chen@diasemi.com>
Cc: "Linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [PATCHv1 -next] WATCHDOG: Watchdog module of DA9052 device
	driver
Message-ID: <20110510111400.GB6865@infomag.iguana.be>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8E4@KCINPUNHJCMS01.kpit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151BA5B8E4@KCINPUNHJCMS01.kpit.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ashish, David,

Driver looks OK at first glance. Will look at it some more later this week.

> +static int __devexit da9052_sm_remove(struct platform_device *dev)
> +{
> +       misc_deregister(&da9052_wdt_miscdev);
> +       strobe_interval = 0;
> +       strobe_mode = 0;
> +       return 0;
> +}

Small remark: here I am missing a kfree(wdt);

Kind regards,
Wim.

