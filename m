Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935Ab1B0FdI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 00:33:08 -0500
Received: from smtp-out.google.com ([74.125.121.67]:24740 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1B0Fc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 00:32:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=CiGvjDGxvA/45pEq3/vmRxz9xyXjkzrosnZJUf7cWlWmYffSafxyzTOA5pr66hAlVj
         gHhtn2ukLu/QZKSn8nQQ==
Date: Sat, 26 Feb 2011 21:32:50 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mariusz Kozlowski <mk@lab.zgora.pl>
cc: Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Eric Dumazet <eric.dumazet@gmail.com>, linux-next@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: fix ksize() build error
In-Reply-To: <1298747426-8236-1-git-send-email-mk@lab.zgora.pl>
Message-ID: <alpine.DEB.2.00.1102262132320.12215@chino.kir.corp.google.com>
References: <20110225105205.5a1309bb.randy.dunlap@oracle.com> <1298747426-8236-1-git-send-email-mk@lab.zgora.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 26 Feb 2011, Mariusz Kozlowski wrote:

> mm/slub.c: In function 'ksize':
> mm/slub.c:2728: error: implicit declaration of function 'slab_ksize'
> 
> slab_ksize() needs to go out of CONFIG_SLUB_DEBUG section.
> 
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>

Acked-by: David Rientjes <rientjes@google.com>
