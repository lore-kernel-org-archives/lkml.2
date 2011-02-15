Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821Ab1BOMYT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 07:24:19 -0500
Received: from cantor.suse.de ([195.135.220.2]:36208 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921Ab1BOMYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 07:24:17 -0500
Date: Tue, 15 Feb 2011 04:21:50 -0800
From: Greg KH <gregkh@suse.de>
To: wei_wang@realsil.com.cn
Cc: devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rts_pstor: fix sparse warning
Message-ID: <20110215122150.GA21933@suse.de>
References: <1297732534-22328-1-git-send-email-wei_wang@realsil.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297732534-22328-1-git-send-email-wei_wang@realsil.com.cn>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 09:15:34AM +0800, wei_wang@realsil.com.cn wrote:
> From: wwang <wei_wang@realsil.com.cn>
> 
> Fix some sparse warning

What sparse warnings did you fix?

You deleted whole functions, why?

Please provide a much more detailed description of your changes and
resend the patch.

thanks,

greg k-h
