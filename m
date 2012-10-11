Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983Ab2JKTOC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 15:14:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38770 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932667Ab2JKTOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 15:14:00 -0400
Date: Thu, 11 Oct 2012 15:13:58 -0400 (EDT)
Message-Id: <20121011.151358.751483166836653953.davem@davemloft.net>
To: catalin.marinas@arm.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        dhowells@redhat.com
Subject: Re: [PATCH 4/4] sparc: Automatically generate trivial UAPI headers
From: David Miller <davem@davemloft.net>
In-Reply-To: <1349972285-22830-5-git-send-email-catalin.marinas@arm.com>
References: <1349972285-22830-1-git-send-email-catalin.marinas@arm.com>
	<1349972285-22830-5-git-send-email-catalin.marinas@arm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Catalin Marinas <catalin.marinas@arm.com>
Date: Thu, 11 Oct 2012 17:18:05 +0100

> This patch removes several trivial UAPI headers that were simply including
> the asm-generic files as they can be automatically generated.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>

Acked-by: David S. Miller <davem@davemloft.net>
