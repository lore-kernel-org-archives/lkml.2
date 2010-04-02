Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab0DBB3t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:29:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40495
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757293Ab0DBB31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:29:27 -0400
Date: Thu, 01 Apr 2010 18:29:26 -0700 (PDT)
Message-Id: <20100401.182926.241031321.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk.c: remove duplicate const
From: David Miller <davem@davemloft.net>
In-Reply-To: <0D753D10438DA54287A00B0270842697636A7E957A@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636A7E956D@AUSP01VMBX24.collaborationhost.net>
	<20100401.182004.197314081.davem@davemloft.net>
	<0D753D10438DA54287A00B0270842697636A7E957A@AUSP01VMBX24.collaborationhost.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Thu, 1 Apr 2010 20:28:33 -0500

> Isn't that a C++ and not a C feature?

I don't think so.

> If it is valid in C then I guess the sparse people should be informed.

Perhaps.
