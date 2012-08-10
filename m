Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab2HJG2q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 02:28:46 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34811 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355Ab2HJG2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 02:28:43 -0400
Date: Fri, 10 Aug 2012 09:28:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "devendra.aaru" <devendra.aaru@gmail.com>
Cc: Ben Chan <benchan@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: gdm72xx: fix reference counting in
 gdm_wimax_event_init
Message-ID: <20120810062829.GA4546@mwanda>
References: <1343141382-31087-1-git-send-email-benchan@chromium.org>
 <CAHdPZaOTvF=e3j8ypzK8_V5Uh_8Nk1U74uVe4tcXs+cdQvimjg@mail.gmail.com>
 <CAC5Y2nMeYvKhMjPFFa-3tGLOOyxXX1B8MZSbXrMLsNDPJmdmzA@mail.gmail.com>
 <CAHdPZaPwUHHUyvgU1N=FAggF5Gg_p7cf-290Yd1+i+9eNyDY1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHdPZaPwUHHUyvgU1N=FAggF5Gg_p7cf-290Yd1+i+9eNyDY1g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben, I'm confused.  Do you have a way to test this, or are you just
doing manual review?

regards,
dan carpenter

