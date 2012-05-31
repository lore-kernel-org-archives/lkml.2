Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251Ab2EaFAA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:00:00 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:64595 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab2EaE7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 00:59:21 -0400
MIME-Version: 1.0
In-Reply-To: <20120531042249.GG9850@tassilo.jf.intel.com>
References: <1336431315-29736-1-git-send-email-andi@firstfloor.org>
 <1338429749-5780-1-git-send-email-tdmackey@twitter.com> <20120531042249.GG9850@tassilo.jf.intel.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 31 May 2012 00:59:00 -0400
Message-ID: <CAHGf_=rT+X9PpJhfr=1GdRQ-5GALUHbt3txJCMDnus_C7Pkcug@mail.gmail.com>
Subject: Re: [PATCH v4] slab/mempolicy: always use local policy from interrupt context
To: Andi Kleen <ak@linux.intel.com>
Cc: David Mackey <tdmackey@twitter.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, penberg@kernel.org, cl@linux.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 12:22 AM, Andi Kleen <ak@linux.intel.com> wrote:
>> [tdmackey@twitter.com: Rework patch logic and avoid dereference of current
>> task if in interrupt context.]
>
> avoiding this reference doesn't make sense, it's totally valid.
> This is based on a older version. I sent the fixed one some time ago.

Where? I think David's version is most cleaner one.

 Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
