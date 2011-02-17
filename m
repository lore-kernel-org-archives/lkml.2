Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757329Ab1BQR25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 12:28:57 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:60126 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab1BQR2z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 12:28:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
Subject: Re: [PATCHv2 07/11] unicore32 core architecture: mm related: fault handling
Date: Thu, 17 Feb 2011 18:28:50 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        "'Greg KH'" <greg@kroah.com>
References: <02ef01cbcb48$67f4ee60$37decb20$@mprc.pku.edu.cn>
In-Reply-To: <02ef01cbcb48$67f4ee60$37decb20$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102171828.50183.arnd@arndb.de>
X-Provags-ID: V02:K0:pPxjsKghA3DbL7qKS/7nqSxPolY6saVyH4ImJ7O5dyS
 x0BRu3cjFm6uN6MS3cEb/OTwKcarlO525Onlu1c8OLoe98kWvn
 1dX6tUB+G8pwj6ToR476NdDqBYRJRBAalCuN9Y8NmIp5kdYrrE
 Y6r8mAxdlAy3tm6wjZcr3EwYlDblzNYFszpDKDu5QNsAXVjfVf
 E0yYpVzBxAPQHzVQRSDUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 13 February 2011, Guan Xuetao wrote:
> This patch implements fault handling of memory management.
> 
> Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>

Reviewed-by: Arnd Bergmann <arnd@arndb.de>
