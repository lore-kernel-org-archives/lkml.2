Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab1I3WqL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 18:46:11 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:56719 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750848Ab1I3WqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 18:46:08 -0400
Subject: Re: [RFCv2][PATCH 1/4] break units out of string_get_size()
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        James.Bottomley@HansenPartnership.com
In-Reply-To: <4E8634D3.2080504@zytor.com>
References: <20110930203219.60D507CB@kernel>  <4E8634D3.2080504@zytor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Sep 2011 15:46:01 -0700
Message-ID: <1317422761.16137.669.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11093022-5112-0000-0000-000000B5594D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-30 at 14:29 -0700, H. Peter Anvin wrote:
> On 09/30/2011 01:32 PM, Dave Hansen wrote:
> > diff -puN lib/string_helpers.c~string_get_size-pow2 lib/string_helpers.c
> >  
> > +const char *units_10[] = { "B", "kB", "MB", "GB", "TB", "PB",
> > +			   "EB", "ZB", "YB", NULL};
> > +const char *units_2[] = {"B", "KiB", "MiB", "GiB", "TiB", "PiB",
> > +			 "EiB", "ZiB", "YiB", NULL };
> 
> These names are way too generic to be public symbols.

Ack, I managed to drop the static when I broke this out for the third
time. :)

> Another thing worth thinking about is whether or not the -B suffix
> should be part of these arrays.

... or the 'i' for that matter.

I'll give it a go.

-- Dave

