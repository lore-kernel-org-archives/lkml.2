Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab2CGFtV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:49:21 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48808 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751337Ab2CGFtT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:49:19 -0500
X-Sasl-enc: disovPCOzlf8Zffhdrg4tP8Z83itKGjTW5TRdPRUCiRk 1331099354
Date: Tue, 6 Mar 2012 21:46:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Zhengwang Ruan <ruan.zhengwang@gmail.com>
Cc: arve@android.com, chris+android@zenthought.org, devel@driverdev.osuosl.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Staging:android: Initialise buffer and
 buffer_size before used
Message-ID: <20120307054616.GA7775@kroah.com>
References: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com>
 <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 10:36:58AM +0800, Zhengwang Ruan wrote:
> GCC warns 'buffer' and 'buffer_size' are used with being uninitialized, and
> 'buffer' is used as returned value, and 'buffer_size' is initialized using
> uninitialized_var to clear warning.

Doesn't say that for me at all, what version of gcc are you using?  I'm
using 4.6.2 here, and if you are using an older version, then please
upgrade to one smarter than the one you are using.

As you are trying to paper over gcc issues, I can't take this patch,
sorry.

greg k-h
