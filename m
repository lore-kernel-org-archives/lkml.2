Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab2FLBVk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 21:21:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36011 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab2FLBVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 21:21:39 -0400
MIME-Version: 1.0
In-Reply-To: <CAEtiSauZg+sqZ01S0qcqEJsmmgTB3cZvnK-pC6NUerb40TB5rA@mail.gmail.com>
References: <CAEtiSau7w+aUf_pK39JS+-SgRRqHav4b1UZMiNFHCJTNPfN7EQ@mail.gmail.com>
 <4FAD840D.9020009@gmail.com> <CAEtiSauZg+sqZ01S0qcqEJsmmgTB3cZvnK-pC6NUerb40TB5rA@mail.gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Mon, 11 Jun 2012 21:21:17 -0400
Message-ID: <CAHGf_=oooT-FragNNq-xTqskjHvN-gS2_goR=aeXY_UeumgCeA@mail.gmail.com>
Subject: Re: [RFC][PATCH] mm: Update zone->un_reclaimable in direct reclaim path
To: Aaditya Kumar <aaditya.kumar.30@gmail.com>
Cc: linux-kernel@vger.kernel.org, frank.rowand@am.sony.com,
        tim.bird@am.sony.com, takuzo.ohara@ap.sony.com,
        kan.iibuchi@jp.sony.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 14, 2012 at 1:03 PM, Aaditya Kumar
<aaditya.kumar.30@gmail.com> wrote:
> Dear Kosaki-san,
>
> Konnichiwa,
>
>> Today I don't have a time and I didn't read your patch. but I would say my
>> patch
>> passed my hotplug test. so can you please tell us your test case and
>> reproducer?

Sorry for the long delay. Unfortunately your patch is racy and I can't take it.
but I made alternative fixes. Can you please try following patch?


http://permalink.gmane.org/gmane.linux.kernel.mm/79972
