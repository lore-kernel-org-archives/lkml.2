Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752686Ab1FCOeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 10:34:06 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:65134 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990Ab1FCOeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 10:34:05 -0400
Message-ID: <4DE8F0D4.2090008@tilera.com>
Date: Fri, 3 Jun 2011 10:33:56 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Tejun Heo <tj@kernel.org>, Matt Mackall <mpm@selenic.com>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: Re: [PATCH] slub: always align cpu_slab to honor cmpxchg_double requirement
References: <201106021424.p52EO91O006974@lab-17.internal.tilera.com> <alpine.DEB.2.00.1106021015220.18350@chino.kir.corp.google.com> <4DE7D2AC.1070503@tilera.com> <BANLkTinjCbhiwRfQ_aN5wtbYipQB6gv5AA@mail.gmail.com> <alpine.DEB.2.00.1106030905590.27151@router.home>
In-Reply-To: <alpine.DEB.2.00.1106030905590.27151@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/3/2011 10:06 AM, Christoph Lameter wrote:
> On Fri, 3 Jun 2011, Pekka Enberg wrote:
>
>> On Thu, Jun 2, 2011 at 9:13 PM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> > On 6/2/2011 1:16 PM, David Rientjes wrote:
>> >> Acked-by: David Rientjes <rientjes@google.com>
>> Yup. Looks good. Christoph?
> Ok if we do not mind the packing density to be not that tight anymore.
>
> Acked-by: Christoph Lameter <cl@linux.com>

I'm assuming from the acks that I should ask Linus to pull this for 3.0
along with a couple of other minor tile-specific changes.  However, please
let me know if someone else would rather take it into their tree instead --
I don't want to step on any toes.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


