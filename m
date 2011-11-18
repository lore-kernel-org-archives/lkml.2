Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597Ab1KRSd2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 13:33:28 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:41429 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751607Ab1KRSd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 13:33:27 -0500
X-Sasl-enc: jk4x+xHED2QAbcVEVeLFl6uxDXgstseNOcnnMOhPdjfS 1321641206
Date: Fri, 18 Nov 2011 10:31:09 -0800
From: Greg KH <greg@kroah.com>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        balbi@ti.com, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH V2 2/2] usb: dwc3: use debugfs_print_regs32()
Message-ID: <20111118183109.GA4833@kroah.com>
References: <20111118002049.GA24806@mail.gnudd.com>
 <20111118135143.GA1101@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118135143.GA1101@mail.gnudd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 02:51:43PM +0100, Alessandro Rubini wrote:
> This a use example of the regs32 utilities in debugfs, although
> this fuse use ":" as separator between name and value, and debugs
> uses "=" (as it looked to me a more common practice).
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Cc: Felipe Balbi <balbi@ti.com>

Felipe, any objection to me applying this patch?

thanks,

greg k-h
