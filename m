Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757273Ab0DBBUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:20:07 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37131
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757151Ab0DBBUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:20:03 -0400
Date: Thu, 01 Apr 2010 18:20:04 -0700 (PDT)
Message-Id: <20100401.182004.197314081.davem@davemloft.net>
To: hartleys@visionengravers.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk.c: remove duplicate const
From: David Miller <davem@davemloft.net>
In-Reply-To: <0D753D10438DA54287A00B0270842697636A7E956D@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636A7E956D@AUSP01VMBX24.collaborationhost.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H Hartley Sweeten <hartleys@visionengravers.com>
Date: Thu, 1 Apr 2010 20:13:27 -0500

> Noticed during a sparse build.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Isn't it intentional?  The two consts mark different aspects
of the declaration const, both the pointers as well as the
contents pointed to.
