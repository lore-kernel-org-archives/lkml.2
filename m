Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186Ab1ECAyA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 20:54:00 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45032 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754601Ab1ECAx7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 20:53:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZrpLindKgEANRcFRS3sxS2zm3dGbjRIebqbY4yPcNNwkHmRh4SADznU6MoKWTTjJji
         hcws/aP6FQlBehGck4+cW4XKoWtjERBqQi4mwQOdaA09c9EVJD4cqi29aiWUsXLK1CKI
         N2WIfHMnPgUGvk6HIrP5SPqIfCGbUrqCKIBF4=
MIME-Version: 1.0
In-Reply-To: <20110502191535.2D55.A69D9226@jp.fujitsu.com>
References: <20110501163542.GA3204@barrios-desktop>
	<20110501163737.GB3204@barrios-desktop>
	<20110502191535.2D55.A69D9226@jp.fujitsu.com>
Date: Tue, 3 May 2011 09:53:58 +0900
Message-ID: <BANLkTikA-oP9ftAE_TXQdU5yBObgn2KG=g@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: cut down __GFP_NORETRY page allocation failures
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@linux.vnet.ibm.com>,
        Dave Young <hidave.darkstar@gmail.com>, linux-mm <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Dave Chinner <david@fromorbit.com>,
        David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 2, 2011 at 7:14 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> On Mon, May 02, 2011 at 01:35:42AM +0900, Minchan Kim wrote:
>>
>> > Do you see my old patch? The patch want't incomplet but it's not bad for showing an idea.
>>                                      ^^^^^^^^^^^^^^^^
>>                               typo : wasn't complete
>
> I think your idea is eligible. Wu's approach may increase throughput but

Yes. it doesn't change many subtle things and make much fair but the
Wu's concern is order-0 pages with __GFP_NORETRY. By his experiment,
my patch doesn't help much his concern.
The problem I have is I don't have any infrastructure for reproducing
his experiment. :(

> may decrease latency. So, do you have a plan to finish the work?

I want it but the day would be after finishing inorder-putback series. :)
Maybe you have a environment(8core system). If you want it, go ahead. :)

Thanks, KOSAKI.


-- 
Kind regards,
Minchan Kim
