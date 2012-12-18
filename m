Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754455Ab2LRI1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:27:40 -0500
Received: from [80.244.247.6] ([80.244.247.6]:56259 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1754078Ab2LRI1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:27:39 -0500
Date: Tue, 18 Dec 2012 09:27:34 +0100
From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
To: Armando Visconti <armando.visconti@st.com>
Cc: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Pratyush ANAND <pratyush.anand@st.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        spear-devel <spear-devel@list.st.com>
Subject: Re: [PATCH] usb: gadget zero: avoid unnecessary reinit of data in
 f_sourcesink
Message-ID: <20121218082734.GA3289@breakpoint.cc>
References: <1355407879-11784-1-git-send-email-armando.visconti@st.com>
 <20121217154545.GB5931@breakpoint.cc>
 <50CF548C.2080500@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CF548C.2080500@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 06:21:16PM +0100, Armando Visconti wrote:
> >Besides that the patch looks fine :)
> 
> Do you mean that 'inited' should be changed with 'initialized'?
Yes, I do.

> Oh ... my poor english... :(
Don't worry. Others, including myself, do this from time to time as well :)

> 
> Rgds,
> Arm

Sebastian
