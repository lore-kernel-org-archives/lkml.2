Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab0FDJpr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 05:45:47 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:60434 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754893Ab0FDJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 05:45:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kDW/tDdoSoD0QZ/LgfLreWY/ZtSd96K1yBA4M0YH80To1eYuSEasnFtNDag646MKbj
         J7kIYGFkMxAKh3h1rR6hbiYCwri+hEPXbE+C+qc0nM/j+NmD31BmniWRUUkgcDBgoJka
         sI87Z9zUqWitbpADD81cJrKLXzZL/huLb024E=
Date: Fri, 4 Jun 2010 17:49:36 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vitaly Mayatskikh <v.mayatskih@gmail.com>, Vivek Goyal <vgoyal@redhat.com>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH 0/5] kdump: extract log buffer and registers from
 vmcore on NMI button pressing
Message-ID: <20100604094936.GA5975@cr0.nay.redhat.com>
References: <1275464359-1566-1-git-send-email-v.mayatskih@gmail.com>
 <20100602151611.GA3174@redhat.com>
 <87iq60a3rh.wl%vmayatsk@redhat.com>
 <87d3w8xy3q.fsf@basil.nowhere.org>
 <874ohkuwhs.wl%vmayatsk@redhat.com>
 <20100603151347.GC4166@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603151347.GC4166@basil.fritz.box>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 05:13:47PM +0200, Andi Kleen wrote:
>> > NMI would be only needed if the crash kernel is completely
>> > hosed too.
>> 
>> That's the case.
>
>You're saying it booted but is hosed after boot?
>
>That seems like a very obscure case. Is that really common?
>

Actually, I met two of this kind of cases recently.

One was stucked in early_idt_hander() during booting the second kernel,
the other one is even worse, I even can't find where it hangs.
