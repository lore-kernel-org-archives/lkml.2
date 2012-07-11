Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757524Ab2GKSOo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 14:14:44 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56724 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754672Ab2GKSOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 14:14:43 -0400
Message-ID: <1342030482.22278.8.camel@joe2Laptop>
Subject: Re: [PATCH] Documentation/CodingStyle: Mention multi-line macros
 using expressions
From: Joe Perches <joe@perches.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 11:14:42 -0700
In-Reply-To: <alpine.DEB.2.02.1207111329280.3642@oneiric>
References: <alpine.DEB.2.02.1207111329280.3642@oneiric>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 13:32 -0400, Robert P. J. Day wrote:
[]
> diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
[]
> +A newer technique is to use the GCC extension of being able to place
> +statements and declarations in an expression, as with this example from
> +the <linux/kernel.h> header file:
> +
> +#define roundup(x, y) (				\
> +{						\
> +        const typeof(y) __y = y;		\
> +        (((x) + (__y - 1)) / __y) * __y;	\
> +}						\
> +)

Hi Robert.

How about the phrase "GCC's statement expression extension"
or maybe give a link like:
http://gcc.gnu.org/onlinedocs/gcc/Statement-Exprs.html

Please put the opening ({ and closing )} on a single line.
It's shorter and makes grep easier.

#define statement_expression(args)		\
({						\
	etc					\
})


