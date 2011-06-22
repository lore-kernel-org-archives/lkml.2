Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605Ab1FVACx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 20:02:53 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47719 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757402Ab1FVACu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 20:02:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:references:in-reply-to
         :mime-version:message-id:x-uid:x-length:cc:content-type
         :content-transfer-encoding;
        b=cOrotyOtZkqV78E/uTBnvKXuZJ1R3JUFk7tmpRG3NaTqLi8lFcvzQ3d+Py6ErmBRt0
         nAxaiMIyuzWjAXgGoO93/4K0n3w1aX47r7+yI0SlAoAIMxQP/m4MIZWdymKrJ/zzoSas
         UL9LsFqWh6dSnjBQi4b+CB5SBiMw9r4PjnzLg=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
To: Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH 1/2 V2] ksm: take dirty bit as reference to avoid volatile pages scanning
Date: Wed, 22 Jun 2011 08:02:35 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.39; KDE/4.5.5; i686; ; )
References: <201106212055.25400.nai.xia@gmail.com> <201106212126.06726.nai.xia@gmail.com> <20110621214233.GN25383@sequoia.sous-sol.org>
In-Reply-To: <20110621214233.GN25383@sequoia.sous-sol.org>
MIME-Version: 1.0
Message-Id: <201106220802.35349.nai.xia@gmail.com>
X-Length: 1772
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>, Chris Wright <chrisw@sous-sol.org>,
        Rik van Riel <riel@redhat.com>, "linux-mm" <linux-mm@kvack.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 June 2011 05:42:33 you wrote:
> * Nai Xia (nai.xia@gmail.com) wrote:
> > This patch makes the page_check_address() can validate if a subpage is
> > in its place in a huge page pointed by the address. This can be useful when
> > ksm does not split huge pages when looking up the subpages one by one.
> 
> Just a quick heads up...this patch does not compile by itself.  Could you
> do a little patch cleanup?  Start with just making sure the Subject: is
> correct for each patch.  Then make sure the 3 are part of same series.
> And finally, make sure each is stand alone and complilable on its own.

Oh, indeed, there is a kvm & mmu_notifier related patch not named in a series.
But with a same email thread ID, I think.... I had thought it's ok...
I'll reformat this patch set to fullfill these requirements. 
Thanks for reviewing. 
(Sorry for repeated mail, I forgot to Cc the list..)


Nai

> 
> thanks,
> -chris
> 
