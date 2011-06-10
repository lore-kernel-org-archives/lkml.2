Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab1FJILt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 04:11:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47067 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab1FJILn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 04:11:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=qwRfWAHQ0EKZ3rISwiZuZVHZCzvtn9cEVls4PNHqaemqXHrJT13zjtRm/WWzs3Vbbq
         1yevLEByrowQo4Sv4ufUin5a4hUg3F37UUtDOqVf6EgGZQhedNJq6XGiV/lfDL+9V3IU
         HvQ9fm+7jj6Da9Qq9wZMu5D+dQ+zBgFDZw1JI=
MIME-Version: 1.0
In-Reply-To: <20110610004331.13672278.akpm@linux-foundation.org>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com>
	<BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com>
	<BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com>
	<alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>
	<20110601181918.GO3660@n2100.arm.linux.org.uk>
	<alpine.LFD.2.02.1106012043080.3078@ionos>
	<alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com>
	<alpine.LFD.2.02.1106012134120.3078@ionos>
	<4DF1C9DE.4070605@jp.fujitsu.com>
	<20110610004331.13672278.akpm@linux-foundation.org>
Date: Fri, 10 Jun 2011 12:11:42 +0400
Message-ID: <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        rientjes@google.com, linux@arm.linux.org.uk, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, mel@csn.ul.ie,
        kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com, pavel@ucw.cz
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/11, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Fri, 10 Jun 2011 16:38:06 +0900 KOSAKI Motohiro
> <kosaki.motohiro@jp.fujitsu.com> wrote:
>
>> Subject: [PATCH] Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not
>> configured"
>
> Confused.  We reverted this over a week ago.

Should one submit a patch adding a warning to GFP_DMA allocations
w/o ZONE_DMA, or the idea of the original patch is wrong?

-- 
With best wishes
Dmitry
