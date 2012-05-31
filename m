Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933239Ab2EaToq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:44:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44976 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933217Ab2EaTop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:44:45 -0400
Message-ID: <1338493483.7229.2.camel@joe2Laptop>
Subject: Re: [PATCH 4/4] usb: gadget: pch_udc: Fix likely misuse of | for &
From: Joe Perches <joe@perches.com>
To: balbi@ti.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 31 May 2012 12:44:43 -0700
In-Reply-To: <20120531072541.GC5377@arwen.pp.htv.fi>
References: <cover.1338408931.git.joe@perches.com>
	 <2530fb0cbede64dad718d41012156043d1ca424e.1338408931.git.joe@perches.com>
	 <20120531072541.GC5377@arwen.pp.htv.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 10:25 +0300, Felipe Balbi wrote:
> On Wed, May 30, 2012 at 01:25:57PM -0700, Joe Perches wrote:
> > Using | with a constant is always true.
> > Likely this should have be &.
> > Signed-off-by: Joe Perches <joe@perches.com>
> this looks good to me. Do you want me to carry it on my tree ?
> If you want to carry it out as a fix:
> Acked-by: Felipe Balbi <balbi@ti.com>

I presume that question is for Greg.


