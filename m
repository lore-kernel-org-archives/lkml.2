Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2GPR5R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 13:57:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35859 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552Ab2GPR5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 13:57:14 -0400
MIME-Version: 1.0
In-Reply-To: <874np7r4ee.fsf@erwin.mina86.com>
References: <1342455272-32703-1-git-send-email-js1304@gmail.com>
	<874np7r4ee.fsf@erwin.mina86.com>
Date: Tue, 17 Jul 2012 02:57:14 +0900
Message-ID: <CAAmzW4OS7=xfm0shxsi0k8kJ=2oNs4MQAEJ=EJv_xRydrukF1w@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: correct return value of migrate_pages()
From: JoonSoo Kim <js1304@gmail.com>
To: Michal Nazarewicz <mina86@tlen.pl>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Christoph Lameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/17 Michal Nazarewicz <mina86@tlen.pl>:
> Acked-by: Michal Nazarewicz <mina86@mina86.com>

Thanks.

> Actually, it makes me wonder if there is any code that uses this
> information.  If not, it would be best in my opinion to make it return
> zero or negative error code, but that would have to be checked.

I think that, too.
I looked at every callsites for migrate_pages() and there is no place
which really need fail count.
This function sometimes makes caller error-prone,
so I think changing return value is preferable.

How do you think, Christoph?
