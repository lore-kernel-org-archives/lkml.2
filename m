Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220Ab0K1Bje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 20:39:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35365
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab0K1Bjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 20:39:32 -0500
Date: Sat, 27 Nov 2010 17:39:58 -0800 (PST)
Message-Id: <20101127.173958.71105674.davem@davemloft.net>
To: tdent48227@gmail.com
Cc: sage@newdream.net, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] Net: ceph: Makefile: Remove unnessary code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1290389030-2743-1-git-send-email-tdent48227@gmail.com>
References: <1290389030-2743-1-git-send-email-tdent48227@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tracey Dent <tdent48227@gmail.com>
Date: Sun, 21 Nov 2010 20:23:50 -0500

> Remove the if and else conditional because the code is in mainline and there
> is no need in it being there.
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>

Applied, thanks.
