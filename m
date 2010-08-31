Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0HaGkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Aug 2010 02:40:46 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.27]:57583 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab0HaGko (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Aug 2010 02:40:44 -0400
Message-ID: <4C7CA411.5070601@ladisch.de>
Date: Tue, 31 Aug 2010 08:41:21 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Simon Arlott <simon@fire.lp0.eu>
CC: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: output an error message when the pipe type doesn't
 match the endpoint type
References: <4C7C279C.507@simon.arlott.org.uk>
In-Reply-To: <4C7C279C.507@simon.arlott.org.uk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-usb@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Arlott wrote:
> Commit f661c6f8c67bd55e93348f160d590ff9edf08904 adds a check of the pipe type if
> CONFIG_USB_DEBUG is enabled,

I didn't see that commit last year, but wouldn't it break devices like
the ESI MIDI Mate whose descriptors want to have low-speed bulk transfers
and where the driver has to submit interrupt transfers instead to get it
to work at all?


Regards,
Clemens
