Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab2HFPom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:44:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:43324 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489Ab2HFPok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:44:40 -0400
MIME-Version: 1.0
In-Reply-To: <f54214e7-cee4-4cbf-aad1-6c1f91867879@default>
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
	<CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
	<b9bee363-321e-409a-bc8e-65ffed8a1dc5@default>
	<CAOJsxLHe6egmMWdEAGj7DGHHX-hqYMhVWDggny9CsT0H-DOL-g@mail.gmail.com>
	<f54214e7-cee4-4cbf-aad1-6c1f91867879@default>
Date: Mon, 6 Aug 2012 18:44:38 +0300
X-Google-Sender-Auth: sx2CbEaD11R9xHR7C2WhkwrVM_U
Message-ID: <CAOJsxLHyPj6KrVkB5nj-9vFBXKmn5BN4ArN_7MDmTeVEG3N3Gw@mail.gmail.com>
Subject: Re: [RFC/PATCH] zcache/ramster rewrite and promotion
From: Pekka Enberg <penberg@kernel.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 5:07 PM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> I'm OK with placing it wherever kernel developers want to put
> it, as long as the reason is not NIMBY-ness. [1]  My preference
> is to keep all the parts together, at least for the review phase,
> but if there is a consensus that it belongs someplace else,
> I will be happy to move it.

I'd go for core code in mm/zcache.c and mm/ramster.c, and move the
clustering code under net/ramster or drivers/ramster.
