Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567Ab1EITwh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 15:52:37 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60569
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574Ab1EITwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 15:52:33 -0400
Date: Mon, 09 May 2011 12:52:01 -0700 (PDT)
Message-Id: <20110509.125201.15236407.davem@davemloft.net>
To: joe@perches.com
Cc: grundler@parisc-linux.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/4] tulip: Convert uses of KERN_DEBUG
From: David Miller <davem@davemloft.net>
In-Reply-To: <7686b8ddd70df6d46eac56b40bedc4b4d267af3f.1304970062.git.joe@perches.com>
References: <cover.1304970062.git.joe@perches.com>
	<7686b8ddd70df6d46eac56b40bedc4b4d267af3f.1304970062.git.joe@perches.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Mon,  9 May 2011 12:45:22 -0700

> Convert logging messages to more current styles.
> 
> Added -DDEBUG to Makefile to maintain current message logging.
> This could be converted to a specific CONFIG_TULIP_DEBUG option.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
