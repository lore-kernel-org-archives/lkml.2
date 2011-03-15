Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751611Ab1COEeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:34:25 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:56605 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750813Ab1COEeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:34:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX19gteFVBYNgCTlfdbu8oc5PRtYwFTngRxkTnzCs5N
	4RSCCQZ+u0guLo
Subject: Re: Where to get the network NIC's firmware? rtl_nic/rtl8105e-1.fw
From: Mike Galbraith <efault@gmx.de>
To: piotr@hosowicz.com
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4D7E42A6.70409@example.com>
References: <4D7E42A6.70409@example.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Mar 2011 05:34:19 +0100
Message-ID: <1300163659.8209.11.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-14 at 17:30 +0100, Piotr Hosowicz wrote:
> Hello,
> 
> I do no have it and my Debian package doesn't have it either. I cannot 
> build and test linux-next kernels, as a minute ago. It searches for 
> rtl_nic/rtl8105e-1.fw.

I would think you could just download the linux driver from the vendor,
and pluck the firmware out.  Having spent a half hour trying to do that,
I couldn't get there from here, so.. dunno.

	-Mike

