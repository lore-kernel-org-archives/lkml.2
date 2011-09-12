Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab1ILOn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:43:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:51456 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755899Ab1ILOn5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:43:57 -0400
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Date: Mon, 12 Sep 2011 16:43:31 +0200
In-Reply-To: <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
References: <20110907191045.GA13475@quad> <4E6E0D0B.3080306@gmail.com>
	 <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	 <4E6E181E.9080506@gmail.com>
	 <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1315838611.26517.51.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-09-12 at 16:40 +0200, Stephane Eranian wrote:
> I don't think this should be the test to detect endianess.

You should be able to tell the endianness from the PERF_MAGIC string, it
stores the string as a u64, so depending on endianness it reads back as
either: PERFFILE or ELIFFREP or whatever the bswap64 result is.
