Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754404Ab0IWJvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 05:51:25 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:62924 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481Ab0IWJvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 05:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bRu6aJwE1KrCFuS6IdUu11QGqtX0tUDGLwCOTZxNQAVdPcPxNDuJJI7lvr2rMrITCh
         BWUj5riXMImAWLI1xhT8j1vuaA0VBPnt2zw8+UuSh/u4pMNQ1MA6Yh4+8WRpZ8ILeqF0
         DFaKra3g3iziupwSAgUXs3rOlB+BLoeCoBw6c=
MIME-Version: 1.0
In-Reply-To: <20100921214847.GF26290@redhat.com>
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com>
	<20100921214847.GF26290@redhat.com>
Date: Thu, 23 Sep 2010 17:51:23 +0800
Message-ID: <AANLkTimQkiOdYetK8RSgACPukJvuYN2vyPziox0nvXVB@mail.gmail.com>
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic constants
From: huang ying <huang.ying.caritas@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Don,

On Wed, Sep 22, 2010 at 5:48 AM, Don Zickus <dzickus@redhat.com> wrote:
> On Fri, Sep 10, 2010 at 10:51:00AM +0800, Huang Ying wrote:
>> Replace the NMI related magic numbers with symbol constants.
>
> Hi Huang,
>
> Sorry for disappearing for a week..
>
> Ingo asked me to shepherd these patches.  I finally got around to do some
> testing on them.  I'll do some more tomorrow.

Thanks. I will post a new version in next week according to comments
collected so far.

> Anyway, I don't have a problem with patches 1-3 and 6 (I guess the rename
> and rename again doesn't really bother me and it kinda makes some logical
> sense).
>
> I am ok with most of patch 4 but I was wondering if you could split out
> the part of using other cpus to access the reason register.  To me it seem
> like the nmi handler rewrite and allowing !bsp cpus to access the reason
> registers were two different ideas.  For bisecting reasons it would be
> easier to seperate them in case we have problems with lost NMIs later.  It
> would be easier to determine if the lost NMIs were from the rewrite or the
> migration of the reason register to other cpus.

Yes. It's reasonable, I will do it.

Best Regards,
Huang Ying
