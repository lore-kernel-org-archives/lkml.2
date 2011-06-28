Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab1F1UkR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 16:40:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:43251 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751364Ab1F1UkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 16:40:03 -0400
X-Sasl-enc: kkzSLBIiPdItvsD7IFik/pPYKyuPjPV0MnaTnuuBdK8J 1309293602
Date: Tue, 28 Jun 2011 13:25:15 -0700
From: Greg KH <greg@kroah.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: use videobuf2 framework for
 drivers/staging/dt3155v4l driver
Message-ID: <20110628202515.GA9177@kroah.com>
References: <201105282145.27809.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105282145.27809.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 09:45:27PM +0300, Marin Mitov wrote:
> This patch transforms drivers/staging/dt3155v4l driver to use videobuf2 framework.
> Tested and works with "xawtv -f".
> 
> Either streaming API or read method should be selected during kernel configuration.

I've applied this, but why would you ever not want to use the streaming
api?

thanks,

greg k-h
