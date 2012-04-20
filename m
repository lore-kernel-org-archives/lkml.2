Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539Ab2DTRnk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:43:40 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:35229 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2DTRnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:43:39 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "PINTU KUMAR" <pintu_agarwal@yahoo.com>
Subject: Re: Latest CMA patches required for kernel3.3 ?
References: <1334939015.7870.YahooMailNeo@web162003.mail.bf1.yahoo.com>
Date: Fri, 20 Apr 2012 19:43:36 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.wc2riya33l0zgt@mpn-glaptop>
In-Reply-To: <1334939015.7870.YahooMailNeo@web162003.mail.bf1.yahoo.com>
User-Agent: Opera Mail/11.62 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2012 18:23:35 +0200, PINTU KUMAR <pintu_agarwal@yahoo.com> wrote:
> Can somebody point me to the latest CMA patches repository?

git://git.linaro.org/people/mszyprowski/linux-dma-mapping.git 3.4-rc1-cma-v24

> I need CMA patches for ubuntu.
>
> I upgraded my ubuntu kernel with kernel3.3 in order to use CMA.  But I think
> CMA is not included with kernel 3.3 release.

No, it is not.  It also won't be in 3.4.  It may end up in 3.5.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
