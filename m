Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161694Ab2CSQOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 12:14:06 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54702 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756805Ab2CSQOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 12:14:01 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1203190854560.16879@router.home>
References: <CA+1xoqfCTXxXsbfUjttuOVutyD_FzYS8PoOoAOOtB72P8SwdVg@mail.gmail.com>
 <20120318141943.GA28850@1984> <CA+1xoqcQYqCgQb=1M5PVkm=6SBhV2oJxJ2CtBp=gAvZM36Kc2Q@mail.gmail.com>
 <20120319002811.GA30408@1984> <alpine.DEB.2.00.1203190854560.16879@router.home>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Mon, 19 Mar 2012 18:13:39 +0200
Message-ID: <CA+1xoqdo5zvUe+=BYr42iEEq9mU=kd1zVxrGhQc0sNYqbpBkNQ@mail.gmail.com>
Subject: Re: netfilter: Hung task
To: Christoph Lameter <cl@linux.com>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>, kaber@trash.net,
        davem@davemloft.net, Dave Jones <davej@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 3:56 PM, Christoph Lameter <cl@linux.com> wrote:
> This is sually something causing memory corruption. Please enable
> debugging to get backtrace that help to debutg this. CONFIG_SLUB_DEBUG_ON
> will do the trick or passing "slub_debug" on the kernel command line.

The kernel was compiled with SLUB_DEBUG_ON, there's nothing coming out
of the slub before that hang message, nor after it.
