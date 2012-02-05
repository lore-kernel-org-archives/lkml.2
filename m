Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab2BER4J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 12:56:09 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57368 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751799Ab2BER4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 12:56:07 -0500
X-Sasl-enc: +KYvYUmr1B/E/0dUIhvdicN6WOZKhKYPtzfnKF8RNWMJ 1328464565
Date: Sun, 5 Feb 2012 08:40:09 -0800
From: Greg KH <greg@kroah.com>
To: Knut Petersen <Knut_Petersen@t-online.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        mchehab@infradead.org
Subject: Re: [BUG] v3.2.1: circular locking dvb_device_open /
 videobuf_dvb_find_frontend
Message-ID: <20120205164009.GA5677@kroah.com>
References: <4F170E93.5070604@t-online.de>
 <4F2E8537.9070308@t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2E8537.9070308@t-online.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 02:33:43PM +0100, Knut Petersen wrote:
> Hi Linus!
> 
> The problem still exists in 3.2.4, but nobody seems to be interested ...

Isn't it resolved in 3.3-rc2 already?  If not, please work with the
linux-media developers.

thanks,

greg k-h
