Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900Ab2HDI7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 04:59:09 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57028 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752220Ab2HDI7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 04:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <b9bee363-321e-409a-bc8e-65ffed8a1dc5@default>
References: <c31aaed4-9d50-4cdf-b794-367fc5850483@default>
	<CAOJsxLEhW=b3En737d5751xufW2BLehPc2ZGGG1NEtRVSo3=jg@mail.gmail.com>
	<b9bee363-321e-409a-bc8e-65ffed8a1dc5@default>
Date: Sat, 4 Aug 2012 11:59:04 +0300
X-Google-Sender-Auth: klggmZPjcAiIZHL7uPhARxl3Ioo
Message-ID: <CAOJsxLHe6egmMWdEAGj7DGHHX-hqYMhVWDggny9CsT0H-DOL-g@mail.gmail.com>
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

Hi Dan,

On Wed, Aug 1, 2012 at 12:13 AM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> Ramster does the same thing but manages it peer-to-peer across
> multiple systems using kernel sockets.  One could argue that
> the dependency on sockets makes it more of a driver than "mm"
> but ramster is "memory management" too, just a bit more exotic.

How do you configure it? Can we move parts of the network protocol under
net/ramster or something?

                        Pekka
