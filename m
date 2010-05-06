Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758160Ab0EFNYr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 09:24:47 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:62920 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0EFNYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 09:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <p2g9c9fda241005051824k54e70136v8324d135b44c71b5@mail.gmail.com>
References: <k2ncecb6d8f1004191627w3cd36450xf797f746460abb09@mail.gmail.com> 
	<20100420155122.6f2c26eb.akpm@linux-foundation.org> <20100420230719.GB1432@n2100.arm.linux.org.uk> 
	<4BE14335.10702@ru.mvista.com> <p2g9c9fda241005051824k54e70136v8324d135b44c71b5@mail.gmail.com>
From: Marcelo Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Thu, 6 May 2010 10:24:23 -0300
Message-ID: <n2ycecb6d8f1005060624y8ada0c03yc4fab915b3d13a0a@mail.gmail.com>
Subject: Re: Suspicious compilation warning
To: Kyungmin Park <kmpark@infradead.org>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Christoph Lameter <cl@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Minchan Kim <minchan.kim@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Yinghai Lu <yinghai@kernel.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kyungmin,

On Wed, May 5, 2010 at 22:24, Kyungmin Park <kmpark@infradead.org> wrote:
>
> Hi,
>
> It tested with my board and working.
> Just curious. If NR_SECTION_ROOTS is zero and uninitialized then
> what's problem? Since we boot and working without patch.

The original compiler error message was:

mm/sparse.c: In function '__section_nr':
mm/sparse.c:135: warning: 'root' is used uninitialized in this function

Leaving a variable to be used uninitialized is the issue here.

> Thank you,
> Kyungmin Park

Regards,
Marcelo.
