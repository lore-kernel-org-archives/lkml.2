Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761587Ab2DLAQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 20:16:01 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:56941 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757058Ab2DLAP6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 20:15:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+8MBbJ-Ub9JtJ+nbMScOfcP6HtAjmQ0qZkWOa6H_3A3VHwz7g@mail.gmail.com>
References: <1333479610-13321-1-git-send-email-paul.gortmaker@windriver.com>
	<CAP=VYLroi_uGBUmwEE2g=nH2z-oD6nYwo_D+o+QHMtWERP=yvA@mail.gmail.com>
	<CA+8MBbJ-Ub9JtJ+nbMScOfcP6HtAjmQ0qZkWOa6H_3A3VHwz7g@mail.gmail.com>
Date: Thu, 12 Apr 2012 02:15:57 +0200
Message-ID: <CAA9xbM6vKjhy9LH4f=dQqAKRxjQ=3DpP2_QFL0=fJdx+y47JZw@mail.gmail.com>
Subject: Re: [PATCH] ia64: populate the cmpxchg header with appropriate code
From: =?ISO-8859-1?Q?=C9meric_Maschino?= <emeric.maschino@gmail.com>
To: Tony Luck <tony.luck@intel.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>,
        David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Will this improve anything w.r.t.
https://bugzilla.kernel.org/show_bug.cgi?id=42757

     Emeric


Le 12 avril 2012 01:13, Tony Luck <tony.luck@intel.com> a écrit :
> On Tue, Apr 10, 2012 at 3:35 PM, Paul Gortmaker
> <paul.gortmaker@windriver.com> wrote:
>> Just wondering if you had a chance to look at this, and
>> whether it was OK and in your queue.
>
> My only concern is whether there are users who just include <asm/intrinsics.h>
> to get xchg/cmpxchg ... but I guess it should be easy enough for anyone who
> has breakage in this area to add <asm/cmpxchg.h>
>
>> It has been in linux-next for > 1wk.
>
> Sadly there are few testers for ia64 building linux-next ... so this doesn't
> mean as much as it does for an x86 patch :-(
>
>> I've got a fix for
>> arch/alpha and I can bundle this along with it in a pull
>> request if you don't have it in your queue already.
>
> I don't have it queued. If you want to handle it, that is fine. Add an
>
> Acked-by: Tony Luck <tony.luck@intel.com>
>
> -Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-ia64" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
