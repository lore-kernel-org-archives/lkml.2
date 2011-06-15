Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115Ab1FOQfN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 12:35:13 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55764 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755254Ab1FOQfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 12:35:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=R5/uYBSG6x2D1Q0tlDb8XBb6bld3Vbs5oi30mcCrul/caHCe65O+RsLVMF7v/6425F
         UoAL3zBV3Yw+Sn1D/YyPStS7/+LF2n4ebnj5ohvU9b1JqldIC+ZEBAoOXwkCjGAgFc79
         iWlDn4CJRf5TUt6O8ZsY3BxS7WHRDDW35pVOk=
MIME-Version: 1.0
In-Reply-To: <E1QWsJP-0008GD-8y@eag09.americas.sgi.com>
References: <E1QWsJP-0008GD-8y@eag09.americas.sgi.com>
Date: Wed, 15 Jun 2011 19:12:37 +0300
X-Google-Sender-Auth: zIAHqSE_KEu5A2romWbYP5bzVyk
Message-ID: <BANLkTi=Q+xg=yZHLg6frP61tk9MKfs0G8g@mail.gmail.com>
Subject: Re: [PATCH 6/8 v2] x86, UV: remove cpumask_t from the stack
From: Pekka Enberg <penberg@kernel.org>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 6:47 PM, Cliff Wickman <cpw@sgi.com> wrote:
> From: Cliff Wickman <cpw@sgi.com>
>
> Remove the stack-resident cpumask_t from reset_with_ipi() by allocating
> one per uvhub.
>
> Due to the limited size of the stack the potentially huge cpumask_t may
> cause stack overrun.  We haven't seen it happen yet, but we need to make it
> a practice not to push such structures onto the stack.
>
> Diffed against 3.0.0-rc3
>
> Signed-off-by: Cliff Wickman <cpw@sgi.com>

Reviewed-by: Pekka Enberg <penberg@kernel.org>
