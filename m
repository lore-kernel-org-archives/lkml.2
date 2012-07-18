Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037Ab2GRRsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 13:48:43 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53091 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2GRRsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 13:48:40 -0400
Date: Wed, 18 Jul 2012 10:48:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Subject: Re: multi-second application stall in open()
Message-ID: <20120718174834.GI24336@google.com>
References: <CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
 <CAKA=qzaZweeeYUFD2OHDeAO-SQihSvExAZ=ZnXeY5o5sMWpxJg@mail.gmail.com>
 <CAKA=qzbaM-z7CbASUgq-A7CZWiUq6pdb93e4giYAw63hQK=MCg@mail.gmail.com>
 <20120627173822.GK15811@google.com>
 <CAKA=qzY5FT8rWU=z8DwGB7aF6AvCuT=bH2sOJQafyEPqtbkduQ@mail.gmail.com>
 <20120627175458.GL15811@google.com>
 <CAKA=qzaArsuwuuqHVKgTqwszY_Zx8d690e6UJsOQUvq_4--hjQ@mail.gmail.com>
 <20120629230237.GF21048@google.com>
 <CAKA=qzZVVvhjw4gxxAcaDG1e0Lxwf7ROTm1XgXhavgMAExrAVg@mail.gmail.com>
 <CAOS58YO5oDn9Y=2dPiDPQ8u4kk7ewV2GLfMDZnjnaazkv+N-0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOS58YO5oDn9Y=2dPiDPQ8u4kk7ewV2GLfMDZnjnaazkv+N-0w@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 06:12:58PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Fri, Jun 29, 2012 at 5:37 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> > Wow. Thanks Tejun. I will try and get to this over the weekend, but it
> > may not be until Monday before I can test it.
> 
> Any progress?

Ping.

-- 
tejun
