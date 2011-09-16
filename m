Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1IPPTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 11:19:24 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52534 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679Ab1IPPTX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 11:19:23 -0400
Subject: Re: [PATCH] perf: make perf.data more self-descriptive (v4)
From: Peter Zijlstra <peterz@infradead.org>
To: David Ahern <dsahern@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@elte.hu
Date: Fri, 16 Sep 2011 17:19:13 +0200
In-Reply-To: <4E73622D.5010506@gmail.com>
References: <20110907191045.GA13475@quad> <4E6E0D0B.3080306@gmail.com>
	 <CABPqkBSfQo5E=MJ913E--dc8Fi7VLcFSGNbBf60tOnTLMuVN_w@mail.gmail.com>
	 <4E6E181E.9080506@gmail.com>
	 <CABPqkBQWd=DyRRDhaxwDGrpCs=XqyTUv72+dn7GKsT=kjPqiJg@mail.gmail.com>
	 <1315838611.26517.51.camel@twins>
	 <CABPqkBShe6OG1ukQ=7vn_Mr=Aa_c8jcbo1mYuF+41Euy5_R7Dw@mail.gmail.com>
	 <4E73622D.5010506@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1316186353.10174.29.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-16 at 08:50 -0600, David Ahern wrote:
> 
> ppc data file: header->magic 454c494646524550
> x86 data file: header->magic 454c494646524550
> 
Ok then we need to fix that magic thing..
