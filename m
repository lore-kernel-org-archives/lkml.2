Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826Ab0KHHST (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 02:18:19 -0500
Received: from ozlabs.org ([203.10.76.45]:42210 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab0KHHSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 02:18:18 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anders Kaseorg <andersk@ksplice.com>
Subject: Re: [PATCH] module: Update prototype for ref_module (formerly use_module)
Date: Mon, 8 Nov 2010 17:48:07 +1030
User-Agent: KMail/1.13.5 (Linux/2.6.35-22-generic-pae; KDE/4.5.1; i686; ; )
Cc: linux-kernel@vger.kernel.org, Tim Abbott <tabbott@ksplice.com>
References: <alpine.DEB.2.00.1011051702090.3947@dr-wily.mit.edu>
In-Reply-To: <alpine.DEB.2.00.1011051702090.3947@dr-wily.mit.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011081748.07467.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 6 Nov 2010 07:35:46 am Anders Kaseorg wrote:
> Commit 9bea7f23952d5948f8e5dfdff4de09bb9981fb5f renamed use_module to
> ref_module (and changed its return value), but forgot to update this
> prototype in module.h.

Hmm, didn't one of these go via akpm?

I'll send it along now...

Thanks!
Rusty.
