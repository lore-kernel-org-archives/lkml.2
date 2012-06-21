Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab2FUHsI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 03:48:08 -0400
Received: from corega.com.ru ([195.178.208.66]:48649 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754640Ab2FUHsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 03:48:06 -0400
Date: Thu, 21 Jun 2012 11:48:03 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Devendra Naga <devendra.aaru@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/w1: free the w1_master at w1_free_dev and
 return a correct return value
Message-ID: <20120621074803.GA9980@ioremap.net>
References: <1339949879-26085-1-git-send-email-devendra.aaru@gmail.com>
 <20120620235503.GA31520@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120620235503.GA31520@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2012 at 04:55:03PM -0700, Greg Kroah-Hartman (gregkh@linuxfoundation.org) wrote:
> No, this is wrong, the memory will be freed in w1_master_release(),
> right?  It is not freed here, sorry, this patch is incorrect.

Yes, you are right.
It is exactly that ->release() callback I missed!

-- 
	Evgeniy Polyakov
