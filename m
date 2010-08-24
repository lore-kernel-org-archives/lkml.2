Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787Ab0HXFgU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 01:36:20 -0400
Received: from smtp-out.google.com ([74.125.121.35]:9843 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362Ab0HXFgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 01:36:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=lUJIy5uYqXjrhvOLtHznGpJgDyTTWFk52mmfuni8Uw8V08p5yrSkYGBgpt0UccqVi
	nMSlkPrWJeJnRyngjjCbQ==
Date: Mon, 23 Aug 2010 22:36:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] tty: Remove __GFP_NOFAIL from tty_add_file()
In-Reply-To: <1282625314-2445-1-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1008232235580.411@chino.kir.corp.google.com>
References: <1282625314-2445-1-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Aug 2010, Pekka Enberg wrote:

> This patch removes __GFP_NOFAIL use from tty_add_file() and adds proper error
> handling to the call-sites of the function.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: David Rientjes <rientjes@google.com>
> Signed-off-by: Pekka Enberg <penberg@kernel.org>

Acked-by: David Rientjes <rientjes@google.com>
