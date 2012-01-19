Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2ASWrv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 17:47:51 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38385 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932140Ab2ASWrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 17:47:47 -0500
X-Sasl-enc: p8fM44FzjllZEOPu1/R7yt25Bx4YxfvLbapjjtQ9qNqp 1327013267
Date: Thu, 19 Jan 2012 17:47:37 -0500
From: Greg KH <greg@kroah.com>
To: Peter Naulls <peter@chocky.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ftdi USB serial additional IDs
Message-ID: <20120119224737.GA21558@kroah.com>
References: <4F162DFD.7010200@chocky.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F162DFD.7010200@chocky.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 17, 2012 at 06:27:09PM -0800, Peter Naulls wrote:
> 
> I tested this against 2.6.39 in the Ubuntu kernel, however I see the
> IDs are not in latest 3.2 git.
> 
> This adds IDs for the FTDI controller in the Rainforest Automation Zigbee
> dongle.
> 
> I don't subscribe to this list, please CC responses.

Care to resend with a Signed-off-by: line as the file
Documentation/SubmittingPatches documents so I can accept it and apply
the patch?

Also, please use the scripts/get_maintainer.pl script to figure out who
to email (hint, it would be me and the linux-usb@vger.kernel.org
list...)

thanks,

greg k-h
