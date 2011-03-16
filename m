Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab1CPU2y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 16:28:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:12206 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab1CPU2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 16:28:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=MuiXhMPrFaIQJKf6Wi0s3XVGjdBIkcxzKbnvbu1jt/I/0H8kxT21rq0IA5SIgj4uFs
         dQ0XfGWGCkrJO6+XE9zA==
Date: Wed, 16 Mar 2011 13:28:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: George Spelvin <linux@horizon.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, herbert@gondor.hengli.com.au,
        mpm@selenic.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/8] mm/slub: Remove unnecessary parameter
In-Reply-To: <20110316022805.27719.qmail@science.horizon.com>
Message-ID: <alpine.DEB.2.00.1103161315310.11002@chino.kir.corp.google.com>
References: <20110316022805.27719.qmail@science.horizon.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, George Spelvin wrote:

> setup_object() does not need the page pointer.
> It's a private static function, so no API changes whatsoever.

This needs your signed-off-by line.

After that's fixed,

	Acked-by: David Rientjes <rientjes@google.com>
