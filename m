Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab1HYWzZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 18:55:25 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:48771 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751055Ab1HYWzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 18:55:24 -0400
MIME-Version: 1.0
In-Reply-To: <20110821011240.GG2203@ZenIV.linux.org.uk>
References: <20110821005031.GB10377@gallifrey>
	<20110821011240.GG2203@ZenIV.linux.org.uk>
Date: Thu, 25 Aug 2011 15:55:23 -0700
X-Google-Sender-Auth: 83FTwyGPqUSOEBTrNO4dQukcAlU
Message-ID: <CAA9_cmfCWM1793stQE0Woa2Z0bEqk6j5=MSgEmV5A+=ipiFQow@mail.gmail.com>
Subject: Re: [PATCH] Fix missing 'cnt' in ?: in dmatest
From: Dan Williams <dan.j.williams@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "Dr. David Alan Gilbert" <linux@treblig.org>, linux-kernel@vger.kernel.org,
        nicolas.ferre@atmel.com, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 20, 2011 at 6:12 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Sun, Aug 21, 2011 at 01:50:31AM +0100, Dr. David Alan Gilbert wrote:
>
>> (WTH is x=y?:z legal C anyway?)
>
> gccism.  It's not legal C; it's a gcc extension, and not a pretty one at
> that.  It's almost definitely a bug in this case - what used to be in the
> tree is equivalent to cnt > 0 ? cnt > 0 : 0, i.e. cnt > 0 ? 1 : 0, i.e.
> cnt > 0.  AFAICS, after your patch it does make sense.
>
>> Signed-off-by: Dr. David Alan Gilbert <linux@treblig.org>

Thanks, I'll take this through the async_tx.git tree.

--
Dan
