Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146Ab2JSWO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:14:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51471 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002Ab2JSWOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:14:24 -0400
MIME-Version: 1.0
In-Reply-To: <1350570446.22036@cat.he.net>
References: <1350570446.22036@cat.he.net>
Date: Fri, 19 Oct 2012 15:14:22 -0700
X-Google-Sender-Auth: aqw5822qzciDh2aW5tJO8KTwEH8
Message-ID: <CANeU7QkUdeR6HyDEVF1fkm9EN=SEkcuY0QPyZxpYnGAzDj7+kg@mail.gmail.com>
Subject: Re: [PATCH] Documentation/sparse.txt: document context annotations
 for lock checking
From: Christopher Li <sparse@chrisli.org>
To: Ed Cashin <ecashin@coraid.com>
Cc: akpm@linux-foundation.org, josh@joshtriplett.org, rob@landley.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-sparse@vger.kernel.org, sam@ravnborg.org, ak@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 7:27 AM, Ed Cashin <ecashin@coraid.com> wrote:
> The context feature of sparse is used with the Linux kernel
> sources to check for imbalanced uses of locks.  Document the
> annotations defined in include/linux/compiler.h that tell sparse
> what to expect when a lock is held on function entry, exit, or
> both.
>
> Signed-off-by: Ed Cashin <ecashin@coraid.com>

Signed-off-by: Christopher Li <sparse@chrisli.org>

Chris
