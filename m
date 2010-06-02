Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0FBOGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 10:06:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:44644
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758242Ab0FBOGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 10:06:37 -0400
Date: Wed, 02 Jun 2010 07:06:47 -0700 (PDT)
Message-Id: <20100602.070647.106817718.davem@davemloft.net>
To: fthain@telegraphics.com.au
Cc: geert@linux-m68k.org, joe@perches.com, p_gortmaker@yahoo.com,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-m68k@vger.kernel.org
Subject: Re: [PATCH 2/2] mac8390: raise error logging priority
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.OSX.2.00.1006011739160.299@localhost>
References: <alpine.OSX.2.00.1005312244520.1490@localhost>
	<20100531.060225.68146363.davem@davemloft.net>
	<alpine.OSX.2.00.1006011739160.299@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Tue, 1 Jun 2010 22:18:56 +1000 (EST)

> Log error conditions using KERN_ERR priority.
> 
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>

Applied, thank you.
