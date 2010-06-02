Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756679Ab0FBGjP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 02:39:15 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:57468 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073Ab0FBGjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 02:39:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=NWtzMwtm2BfUvQY6eRw3lpodO6LsHAdSQ72m2xNwliN46qbCj0//I9cFXhXgsFyC6D
         SYOj53nKN9tNfvgv9aV8Xpt2Hy02/EPOeDMUGV2BvWRwQGPOqRyqz9I6xideIJb0cFJs
         C20CnC/G9iVYnlEytxGB5B+kfhvBtYTm6Rt1Y=
Subject: Re: [PATCH] module: module_unload_init() cleanup
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
       Nick Piggin <npiggin@suse.de>
In-Reply-To: <201006021555.55007.rusty@rustcorp.com.au>
References: <1275456740.2638.143.camel@edumazet-laptop>
	 <201006021546.34363.rusty@rustcorp.com.au>
	 <201006021555.55007.rusty@rustcorp.com.au>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Jun 2010 08:39:07 +0200
Message-ID: <1275460747.2638.144.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mercredi 02 juin 2010 à 15:55 +0930, Rusty Russell a écrit :

> Hmm, and checked for warnings:
> 
> kernel/module.c: In function ‘module_unload_init’:
> kernel/module.c:529: warning: unused variable ‘cpu’
> 
> Fixed,
> Rusty.

Oops, sorry Rusty, thanks !


