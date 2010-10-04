Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab0JDXca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:32:30 -0400
Received: from ozlabs.org ([203.10.76.45]:41287 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752242Ab0JDXc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:32:28 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: matt mooney <mfm@muteddisk.com>
Subject: Re: [PATCH v4 2/2] bsearch: prevent overflow when computing middle comparison element
Date: Tue, 5 Oct 2010 10:02:20 +1030
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: =?iso-8859-1?q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>,
        linux-kernel@vger.kernel.org,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        Tim Abbott <tabbott@ksplice.com>
References: <cover.1257864802.git.andre.goddard@gmail.com> <201009231056.11938.rusty@rustcorp.com.au> <20100924055012.GC18432@haskell.muteddisk.com>
In-Reply-To: <20100924055012.GC18432@haskell.muteddisk.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010051002.21609.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Sep 2010 03:20:12 pm matt mooney wrote:
> > + * bsearch - binary search an array of elements
> > + * @key: pointer to item being searched for
> > + * @base: pointer to data to sort
> 
> The comment for "@base" seems wrong. It appears that it should say "pointer to
> sorted data" or "pointer to search data" instead.

Thanks, fixed:

+ * @base: pointer to first element to search

Cheers,
Rusty.
