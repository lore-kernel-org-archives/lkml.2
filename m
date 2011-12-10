Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755183Ab1LJADf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 19:03:35 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:54768 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755138Ab1LJAD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 19:03:27 -0500
X-Sasl-enc: /7MieD77nyc/fSDB0zdkxf95rLnjw4t+Rfc8NUk3NhPA 1323475404
Date: Fri, 9 Dec 2011 16:00:54 -0800
From: Greg KH <greg@kroah.com>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: Hubert Feurstein <h.feurstein@gmail.com>, jeff.dagenais@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] w1: add fast search for single slave bus
Message-ID: <20111210000054.GD6680@kroah.com>
References: <258EF057-8FF6-4432-A9E5-77F87607C45F@gmail.com>
 <1323017210-14666-1-git-send-email-h.feurstein@gmail.com>
 <20111205122931.GA1550@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111205122931.GA1550@ioremap.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 05, 2011 at 03:29:31PM +0300, Evgeniy Polyakov wrote:
> Hi
> 
> On Sun, Dec 04, 2011 at 05:46:50PM +0100, Hubert Feurstein (h.feurstein@gmail.com) wrote:
> > This enables a much more efficient way of device searching. It uses the
> > 1-wire read-rom operation which allows the direct reading of the slave
> > address. BUT this works only with exactly one slave on the bus.
> 
> Looks good to me, thank you!
> Greg, please pull it into your tree

Um, pull what?  Can someone please send me the whole patch, as I can't
seem to find it anywhere, sorry.

greg k-h
