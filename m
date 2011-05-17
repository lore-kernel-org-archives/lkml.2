Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1EQU1c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 16:27:32 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:49315 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750902Ab1EQU1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 16:27:30 -0400
X-Sasl-enc: NM7zWqQoSMyZQ0Iunu1V8J9AQ07KSQqLdiCT1yJYNpJm 1305664049
Date: Tue, 17 May 2011 13:23:00 -0700
From: Greg KH <greg@kroah.com>
To: matt mooney <mfmooney@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] package: Makefile: add USB/IP userspace utilities
Message-ID: <20110517202300.GA7981@kroah.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
 <5f759d070b6bf0f72d92c632e94e6fe5d9943a96.1305369176.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f759d070b6bf0f72d92c632e94e6fe5d9943a96.1305369176.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 03:55:20AM -0700, matt mooney wrote:
> From: matt mooney <mfm@muteddisk.com>
> 
> Add usbip-src-pkg target to generate a tarball of the userspace source.
> 
> Signed-off-by: matt mooney <mfm@muteddisk.com>
> ---
>  scripts/package/Makefile |   15 ++++++++++++++-

Is this really needed at this point in time?  I'd prefer to wait on it
before we get this code cleaned up a bit better if you don't mind.

thanks,

greg k-h
