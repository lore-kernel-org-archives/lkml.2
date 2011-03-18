Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933013Ab1CRWQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 18:16:55 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43777
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932837Ab1CRWQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 18:16:47 -0400
Date: Fri, 18 Mar 2011 15:17:25 -0700 (PDT)
Message-Id: <20110318.151725.45906817.davem@davemloft.net>
To: vapier@gentoo.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] headers: use __aligned_xx types for userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <1300474237-10980-1-git-send-email-vapier@gentoo.org>
References: <1300474237-10980-1-git-send-email-vapier@gentoo.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Fri, 18 Mar 2011 14:50:37 -0400

> Now that we finally have __aligned_xx exported to userspace, convert
> the headers that get exported over to the proper type.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied.
