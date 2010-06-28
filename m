Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab0F1Qio (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 12:38:44 -0400
Received: from b.mail.sonic.net ([64.142.19.5]:52199 "EHLO b.mail.sonic.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751011Ab0F1Qik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 12:38:40 -0400
X-Greylist: delayed 1636 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2010 12:38:40 EDT
Message-ID: <4C28C908.8090808@twiddle.net>
Date: Mon, 28 Jun 2010 09:08:40 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: Michael Cree <mcree@orcon.net.nz>
CC: Dave Airlie <airlied@gmail.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, mattst88@gmail.com,
       linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org,
       ink@jurassic.park.msu.ru, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org,
       alexdeucher@gmail.com, jglisse@redhat.com
Subject: Re: Problems with alpha/pci + radeon/ttm
References: <20100622145805R.fujita.tomonori@lab.ntt.co.jp>	<AANLkTilMfDfy7BPiuAh9u-tR3kw1Vt_SebMziLUtLM6S@mail.gmail.com>	<4C232AAC.2010200@orcon.net.nz>	<20100627131836T.fujita.tomonori@lab.ntt.co.jp>	<4C272C1C.9000802@orcon.net.nz> <AANLkTinrscp_Vqh69dbH5t5yqNiR4Mgl7T2JRrmWwI4a@mail.gmail.com> <4C286568.60901@orcon.net.nz>
In-Reply-To: <4C286568.60901@orcon.net.nz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2010 02:03 AM, Michael Cree wrote:
> On 28/06/10 11:14, Dave Airlie wrote:
>> The bus error is caused by the kernel, its something alpha specific
>> with how mmap works,
>> I'm not sure if alpha needs some special mmap flags or something,
> 
> Neither am I.  All I know is that Alpha reorders CPU instructions more
> aggressively than most other architectures, the page map size is 8kB,
> and memory accesses must be aligned to the datum size.

There are no special mmap flags on alpha.  The non-cacheable property
is a function of the physical address (e.g. bit 40 set for ev5), and
this has already been taken care of by the kernel.


r~
