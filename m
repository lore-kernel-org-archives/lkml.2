Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab0DOWfF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 18:35:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:52216
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757090Ab0DOWfB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 18:35:01 -0400
Date: Thu, 15 Apr 2010 15:35:05 -0700 (PDT)
Message-Id: <20100415.153505.78059421.davem@davemloft.net>
To: schwab@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] Fix compat uname machine
From: David Miller <davem@davemloft.net>
In-Reply-To: <m2wrw8he8e.fsf@igel.home>
References: <m2wrw8he8e.fsf@igel.home>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Schwab <schwab@linux-m68k.org>
Date: Thu, 15 Apr 2010 18:28:33 +0200

> Mask off personality flags when checking for PER_LINUX32.
> 
> Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>

Acked-by: David S. Miller <davem@davemloft.net>
