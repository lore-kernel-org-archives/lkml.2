Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754339Ab0J3Xtc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 19:49:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56907
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754282Ab0J3Xtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 19:49:31 -0400
Date: Sat, 30 Oct 2010 16:49:54 -0700 (PDT)
Message-Id: <20101030.164954.179924837.davem@davemloft.net>
To: segooon@gmail.com
Cc: kernel-janitors@vger.kernel.org, isdn@linux-pingi.de, acme@redhat.com,
        tj@kernel.org, eparis@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: mISDN: socket: fix information leak to userland
From: David Miller <davem@davemloft.net>
In-Reply-To: <1288429473-21864-1-git-send-email-segooon@gmail.com>
References: <1288429473-21864-1-git-send-email-segooon@gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 30 Oct 2010 13:04:33 +0400

> Structure mISDN_devinfo is copied to userland with the field "name"
> that has the last elements unitialized.  It leads to leaking of
> contents of kernel stack memory.
> 
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>

Applied.
