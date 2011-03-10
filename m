Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752695Ab1CJWMV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:12:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45645
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752937Ab1CJWMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:12:18 -0500
Date: Thu, 10 Mar 2011 14:12:54 -0800 (PST)
Message-Id: <20110310.141254.104056416.davem@davemloft.net>
To: j223yang@asset.uwaterloo.ca
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Patch]ariadne: remove redundant NULL check
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110310172031.GA10734@asset.uwaterloo.ca>
References: <20110310172031.GA10734@asset.uwaterloo.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: j223yang@asset.uwaterloo.ca
Date: Thu, 10 Mar 2011 12:20:31 -0500

> Simply remove redundant 'dev' NULL check. 
> 
> Signed-off-by: Jinqiu Yang<crindy646@gmail.com>

This patch was corrupted by your email client, it turned TAB
characters into spaces which makes the patch unusable.

Also your signoff is badly formed, a space is missing between
your name and the "<" that begins your email address.
