Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116Ab0HQPFP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:05:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:43379 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab0HQPFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:05:12 -0400
Date: Tue, 17 Aug 2010 07:34:36 -0700
From: Greg KH <gregkh@suse.de>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: Uartlite - poll support
Message-ID: <20100817143436.GA17909@suse.de>
References: <1282034525-19207-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282034525-19207-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 10:42:04AM +0200, Michal Simek wrote:
> Hi Greg,
> 
> I am not sure who is responsible for drivers/serial but I see
> that your tty tree contains a lot of serial patches. 
> Could you please add the uartlite poll patch to your tree?

Sure, I'll queue it up for .37.

thanks,

greg k-h
