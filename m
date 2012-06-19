Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751918Ab2FSNUv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 09:20:51 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33469 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2FSNUu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:20:50 -0400
MIME-Version: 1.0
In-Reply-To: <CAHGf_=oooT-FragNNq-xTqskjHvN-gS2_goR=aeXY_UeumgCeA@mail.gmail.com>
References: <CAEtiSau7w+aUf_pK39JS+-SgRRqHav4b1UZMiNFHCJTNPfN7EQ@mail.gmail.com>
	<4FAD840D.9020009@gmail.com>
	<CAEtiSauZg+sqZ01S0qcqEJsmmgTB3cZvnK-pC6NUerb40TB5rA@mail.gmail.com>
	<CAHGf_=oooT-FragNNq-xTqskjHvN-gS2_goR=aeXY_UeumgCeA@mail.gmail.com>
Date: Tue, 19 Jun 2012 18:50:49 +0530
Message-ID: <CAEtiSauAwOT-B=vXsty77avrKU3+7vMxsgmNAs09Zi8_OPs_Tg@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: Update zone->un_reclaimable in direct reclaim path
From: Aaditya Kumar <aaditya.kumar.30@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, frank.rowand@am.sony.com,
        tim.bird@am.sony.com, takuzo.ohara@ap.sony.com,
        kan.iibuchi@jp.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 6:51 AM, KOSAKI Motohiro
<kosaki.motohiro@gmail.com> wrote:
> On Mon, May 14, 2012 at 1:03 PM, Aaditya Kumar
> <aaditya.kumar.30@gmail.com> wrote:
>> Dear Kosaki-san,
>>
>> Konnichiwa,
>>
>>> Today I don't have a time and I didn't read your patch. but I would say my
>>> patch
>>> passed my hotplug test. so can you please tell us your test case and
>>> reproducer?
>
> Sorry for the long delay. Unfortunately your patch is racy and I can't take it.
> but I made alternative fixes. Can you please try following patch?

Hi Kosaki-san,

Thank you for the patch, it seems to fix the issue.

>
>
> http://permalink.gmane.org/gmane.linux.kernel.mm/79972


Regards,
Aaditya Kumar
Sony India Software Centre,
Bangalore.
