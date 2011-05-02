Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373Ab1EBWmX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 18:42:23 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42897
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759192Ab1EBWmV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 18:42:21 -0400
Date: Mon, 02 May 2011 15:41:48 -0700 (PDT)
Message-Id: <20110502.154148.246516437.davem@davemloft.net>
To: lifongsun@gmail.com
Cc: alan@lxorguk.ukuu.org.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] networking: inappropriate ioctl operation should
 return ENOTTY
From: David Miller <davem@davemloft.net>
In-Reply-To: <1303977891-29280-1-git-send-email-lifongsun@gmail.com>
References: <20110427130904.47331a9f@lxorguk.ukuu.org.uk>
	<1303977891-29280-1-git-send-email-lifongsun@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lifeng Sun <lifongsun@gmail.com>
Date: Thu, 28 Apr 2011 16:04:51 +0800

> ioctl() calls against a socket with an inappropriate ioctl operation
> are incorrectly returning EINVAL rather than ENOTTY:
> 
>   [ENOTTY]
>       Inappropriate I/O control operation.
> 
> BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=33992
> 
> Signed-off-by: Lifeng Sun <lifongsun@gmail.com>

Applied, thanks.
