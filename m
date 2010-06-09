Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932332Ab0FIQyc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 12:54:32 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11960 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0FIQyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 12:54:31 -0400
Message-ID: <4C0FC741.4020505@caviumnetworks.com>
Date: Wed, 09 Jun 2010 09:54:25 -0700
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Christoph Egger <siccegge@cs.fau.de>
CC: Ralf Baechle <ralf@linux-mips.org>, Yang Shi <yang.shi@windriver.com>,
       Herbert Xu <herbert@gondor.hengli.com.au>, Tejun Heo <tj@kernel.org>,
       linux-mips@linux-mips.org, linux-kernel@vger.kernel.org,
       vamos@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 2/9] Removing dead CONFIG_GDB_CONSOLE
References: <cover.1275925108.git.siccegge@cs.fau.de> <598418d662edd83225b8b47ead59a5cf18a26fc6.1275925108.git.siccegge@cs.fau.de>
In-Reply-To: <598418d662edd83225b8b47ead59a5cf18a26fc6.1275925108.git.siccegge@cs.fau.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jun 2010 16:54:30.0697 (UTC) FILETIME=[6DDF8190:01CB07F4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2010 04:20 AM, Christoph Egger wrote:
> CONFIG_GDB_CONSOLE doesn't exist in Kconfig, therefore removing all
> references for it from the source code.
>
> Signed-off-by: Christoph Egger<siccegge@cs.fau.de>

Acked-by: David Daney <ddaney@caviumnetworks.com>

> ---
>   arch/mips/cavium-octeon/serial.c    |    4 ----
>   arch/mips/cavium-octeon/setup.c     |    4 ----
>   arch/mips/pmc-sierra/yosemite/irq.c |    4 ----
>   3 files changed, 0 insertions(+), 12 deletions(-)
>

