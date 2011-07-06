Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756022Ab1GFDOs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 23:14:48 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38165 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab1GFDOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 23:14:47 -0400
X-Sasl-enc: JmhTWltunTT7tsfjvs8Md9F5IyDXruoGNUSGk95a7psX 1309922086
Date: Tue, 5 Jul 2011 20:12:52 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfm@muteddisk.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/22] staging: usbip: misc. userspace changes
Message-ID: <20110706031252.GA30442@kroah.com>
References: <cover.1308547654.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1308547654.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 19, 2011 at 10:44:30PM -0700, matt mooney wrote:
> Hi Greg,
> 
> This patch set contains only userspace changes. Next, I will take a look at
> attach and detach, which should soon lead to the reason why usbip is not
> currently working.

Not all of these applied, care to resend the ones that didn't after
rebasing on the current staging-next tree?

thanks,

greg k-h
