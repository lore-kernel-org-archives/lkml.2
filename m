Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1BBXjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 18:39:42 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45095
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751278Ab1BBXjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 18:39:41 -0500
Date: Wed, 02 Feb 2011 15:40:16 -0800 (PST)
Message-Id: <20110202.154016.179951126.davem@davemloft.net>
To: peter.chubb@nicta.com.au
Cc: trivial@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: tcp_ecn is an integer not a boolean
From: David Miller <davem@davemloft.net>
In-Reply-To: <w4wrlim4rf.wl%peter@chubb.wattle.id.au>
References: <w4wrlim4rf.wl%peter@chubb.wattle.id.au>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Chubb <peter.chubb@nicta.com.au>
Date: Thu, 03 Feb 2011 09:49:08 +1100

> 
> There was some confusion at LCA as to why the sysctl tcp_ecn took one
> of three values when it was documented as a Boolean.  This patch fixes
> the documentation.
> 
> Signed-off-by: Peter Chubb <peter.chubb@nicta.com.au>

Applied, thanks Peter.
