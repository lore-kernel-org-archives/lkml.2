Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374Ab2LQPpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:45:52 -0500
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54447 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752647Ab2LQPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:45:51 -0500
Date: Mon, 17 Dec 2012 16:45:45 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Armando Visconti <armando.visconti@st.com>
Cc: balbi@ti.com, gregkh@linuxfoundation.org, pratyush.anand@st.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com
Subject: Re: [PATCH] usb: gadget zero: avoid unnecessary reinit of data in
 f_sourcesink
Message-ID: <20121217154545.GB5931@breakpoint.cc>
References: <1355407879-11784-1-git-send-email-armando.visconti@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355407879-11784-1-git-send-email-armando.visconti@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 03:11:19PM +0100, Armando Visconti wrote:
> In the IN case, since the USB request is allocated only when
> the source/sink function is started and never freed, the USB ept
> buffer needs to be inited only at the beginning. This change
                     ^^^^^^
> results into a more performant g_zero module, especially when
> 'pattern=1' is selected.

Besides that the patch looks fine :)

> Signed-off-by: Armando Visconti <armando.visconti@st.com>

Sebastian
