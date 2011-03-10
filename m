Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab1CJWjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:39:08 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:41659
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752042Ab1CJWjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:39:05 -0500
Date: Thu, 10 Mar 2011 14:39:42 -0800 (PST)
Message-Id: <20110310.143942.183042624.davem@davemloft.net>
To: j223yang@asset.uwaterloo.ca
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] ariadne: remove redundant NULL check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110310223636.GA11399@asset.uwaterloo.ca>
References: <20110310223636.GA11399@asset.uwaterloo.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: j223yang@asset.uwaterloo.ca
Date: Thu, 10 Mar 2011 17:36:37 -0500

> Simply remove redundant 'dev' NULL check.
> Source code uses spaces instead of TAB, except 'printk' and 'return' lines.
> 
> 
> Signed-off-by: Jinqiu Yang <crindy646@gmail.com>

Patch is still corrupted by your email client, the same way as before.
And when you fix it, you don't need to mention this in the commit
message.

Please, take the time to do some testing by sending the patch to
yourself, and then try to apply the patch in the email you receive.
