Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab1ILLiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 07:38:01 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46138 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755216Ab1ILLh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 07:37:59 -0400
X-Sasl-enc: xagl3QiVatNJ/Lbc0vqjFlOGkUkf9zgn8NxMxuRpLn6a 1315827479
Date: Mon, 12 Sep 2011 13:36:41 +0200
From: Greg KH <greg@kroah.com>
To: Krzysztof Kanas <k.kanas@kelvatek.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel  2.6.27.15  oops in PPP
Message-ID: <20110912113641.GA32603@kroah.com>
References: <4E6DCD36.6020104@kelvatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6DCD36.6020104@kelvatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 11:13:26AM +0200, Krzysztof Kanas wrote:
> Hi I am tracing kernel oops in 2.6.27.15 on ARM(CONFIG_CPU_ARM926T=y).

2.6.27.15 is quite old, why that version?  If you are stuck on 2.6.27,
please use a newer stable version of it as odds are this is already
resolved in one of the 40+ releases after yours (current one is
2.6.27.57 I think.)

thanks,

greg k-h
