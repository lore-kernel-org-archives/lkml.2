Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755082Ab1DKTJt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 15:09:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754004Ab1DKTJr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 15:09:47 -0400
Date: Mon, 11 Apr 2011 12:07:53 -0700
From: Greg KH <gregkh@suse.de>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com
Subject: Re: [PATCH 1/5] driver core/platform_device_add_data: set
 platform_data to NULL if !data
Message-ID: <20110411190753.GB21355@suse.de>
References: <20110301153438.GB15633@suse.de>
 <1302081865-2962-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20110411185035.GA7771@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110411185035.GA7771@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 11, 2011 at 08:50:35PM +0200, Uwe Kleine-König wrote:
> Hi Greg,
> 
> do you care for the Reviewed-by: tag from Viresh or should I resend?

Feel free to resend, I'm still working through my patch backlog for
being away for a few weeks...

thanks,

greg k-h
