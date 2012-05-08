Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758096Ab2EHCMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 22:12:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757588Ab2EHCMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 22:12:18 -0400
Date: Mon, 7 May 2012 19:12:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Extcon: add MAX8997 extcon driver
Message-ID: <20120508021214.GA3001@kroah.com>
References: <4FA87BBF.1040107@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA87BBF.1040107@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2012 at 10:49:51AM +0900, Chanwoo Choi wrote:
> This patch add extcon-max8997 driver to support the muic feature
> of Maxim max8997 by using Extcon framework.
> 
> The extcon-max8997 driver is implemented based on 'drivers/misc/
> max8997-muic.c' and then use Extcon interface instead of callback
> function in struct max8997_muic_platform_data to notify cable state
> of notifee which want to know always newly cable state when external
> connector(e.g., USB, TA, JIG) is attached or detached.

Does that mean we can delete the max8997-muic.c driver if this is
accepted?

thanks,

greg k-h
