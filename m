Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab0D3Qr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:47:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43355 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168Ab0D3QrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:47:05 -0400
Date: Thu, 29 Apr 2010 16:13:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] padata: fixes/cleanups
Message-Id: <20100429161325.a5c0691c.akpm@linux-foundation.org>
In-Reply-To: <20100429123636.GD5275@secunet.com>
References: <20100429123636.GD5275@secunet.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 14:36:36 +0200
Steffen Klassert <steffen.klassert@secunet.com> wrote:

> This pachset is based on Andrew's padata review. It applies agains the 
> cryptodev-2.6 tree. Btw. how to route future padata patches upstream,
> still via cryptodev-2.6?

That's OK by me.  I'll often grab stuff (especially if I was cc'ed on
it) and will drop it again if I see a subsystem maintainer took it. 
People use this to delegate the resend-to-sleepy-maintainer job to
myself.  Herbert is less sleepy than many ;)

