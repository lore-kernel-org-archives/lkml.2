Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486Ab2L2W2S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 17:28:18 -0500
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:56690 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753300Ab2L2W2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 17:28:17 -0500
MIME-Version: 1.0
In-Reply-To: <1356811734.16149.1.camel@joe-AO722>
References: <1356754984-13917-1-git-send-email-roland@kernel.org>
 <20121229175625.GA1963@kroah.com> <1356811734.16149.1.camel@joe-AO722>
From: Roland Dreier <roland@purestorage.com>
Date: Sat, 29 Dec 2012 14:27:55 -0800
Message-ID: <CAL1RGDV5fje8+sNQUCgJNKaasZ=pvg4rWrXaz-3cZ+uNgsWDzg@mail.gmail.com>
Subject: Re: [PATCH] printk: Fix incorrect length from print_time() when
 seconds > 99999
To: Joe Perches <joe@perches.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sylvain Munaut <s.munaut@whatever-company.com>,
        Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 12:08 PM, Joe Perches <joe@perches.com> wrote:
> Sylvan Munaut did something similar
> https://lkml.org/lkml/2012/12/5/168

Missed that and duplicated the debugging :(
Sorry Sylvain.

I guess my patch may be preferable, since I happened to use the snprintf()
method that you suggest -- all the open-coded digit-counting seems a bit
verbose and perhaps hard to read and see the equivalence to the sprintf.

But certainly Sylvain fixed this quite a bit earlier and he should get credit.

 - R.
