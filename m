Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab2LUCVA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 21:21:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57355 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LUCUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 21:20:54 -0500
Date: Fri, 21 Dec 2012 04:14:54 +0200
From: Ido Yariv <ido@wizery.com>
To: Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= <sjur@brendeland.net>,
        Sjur =?iso-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@steicsson.com>
Subject: Re: [RFCv2 04/11] remoteproc: Add state RPROC_LOADED
Message-ID: <20121221021454.GB28692@WorkStation.localnet>
References: <1355501220-4572-1-git-send-email-sjur.brandeland@stericsson.com>
 <1355501220-4572-5-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355501220-4572-5-git-send-email-sjur.brandeland@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Fri, Dec 14, 2012 at 05:06:53PM +0100, Sjur Brændeland wrote:
> Add state RPROC_LOADED as firmware loading and startup will be
> different states.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@steicsson.com>

The rproc_state holds the state of the remote processor and it will
still be offline even when the FW is loaded, so I'm not sure if a new
state should be added.

Thanks,
Ido.
