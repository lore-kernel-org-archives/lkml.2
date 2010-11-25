Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab0KYRPa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:15:30 -0500
Received: from cantor.suse.de ([195.135.220.2]:58322 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753983Ab0KYRP2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:15:28 -0500
Date: Thu, 25 Nov 2010 09:16:13 -0800
From: Greg KH <gregkh@suse.de>
To: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, arnd@arndb.de
Subject: Re: [RESEND][BUG][PATCH]-rc: USB: yurex: add .llseek fop to
	file_operations
Message-ID: <20101125171613.GB18152@suse.de>
References: <4CEE8A99.5020906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CEE8A99.5020906@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 26, 2010 at 01:11:05AM +0900, Tomoki Sekiyama wrote:
> Hi Greg-KH,
> Sorry for resending this; To: was not enough.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=23512
> 
> Default llseek operation behavior was changed by the patch named
> "vfs: make no_llseek the default" after the yurex driver was merged,
> so the llseek to yurex is now ignored.
> 
> This patch add llseek fop with default_llseek to yurex driver
> to catch up to the change.
> 
> Signed-off-by: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>

It's in my queue, sorry, been without power and water at home for a few
days, will catch up on this stuff next week...

thanks,

greg k-h
