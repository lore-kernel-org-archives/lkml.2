Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760724Ab2FGRHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:07:12 -0400
Received: from mexforward.lss.emc.com ([128.222.32.20]:46456 "EHLO
	mexforward.lss.emc.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760608Ab2FGRHK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:07:10 -0400
From: <Tao.Guo@emc.com>
To: <shli@kernel.org>
CC: <glorioustao@gmail.com>, <linux-kernel@vger.kernel.org>, <neilb@suse.de>,
        <axboe@kernel.dk>, <stable@vger.kernel.org>,
        <akpm@linux-foundation.org>
Date: Thu, 7 Jun 2012 13:06:42 -0400
Subject: RE: [PATCH 1/2] block: Move general unplug callback function from
 md/raid to blk-core
Thread-Topic: [PATCH 1/2] block: Move general unplug callback function from
 md/raid to blk-core
Thread-Index: Ac1DiTpp6DNO1AwwSdWVlorQcYzPwgBRDhLQ
Message-ID: <5723ED3022C1484092D8E8139108116905581F3D9A@MX18A.corp.emc.com>
References: <1338820911-4733-1-git-send-email-glorioustao@gmail.com>
	<20120605012116.GA357@kernel.org>
	<5723ED3022C1484092D8E8139108116905581F3ACF@MX18A.corp.emc.com>
 <CANejiEVyUiatJ4pKHS9n3skf4uOHh7wKLibQA9e_HK8UFZYmMQ@mail.gmail.com>
In-Reply-To: <CANejiEVyUiatJ4pKHS9n3skf4uOHh7wKLibQA9e_HK8UFZYmMQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-EMM-MHVC: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, I think I will take your suggestions. I am sending another version
of the patch.

Thanks,
-Tao

> -----Original Message-----
> From: shlikernel@gmail.com [mailto:shlikernel@gmail.com] On Behalf Of
> Shaohua Li
> Sent: Wednesday, June 06, 2012 10:07 AM
> To: Guo, Tao
> Cc: glorioustao@gmail.com; linux-kernel@vger.kernel.org; neilb@suse.de;
> axboe@kernel.dk; stable@vger.kernel.org; akpm@linux-foundation.org
> Subject: Re: [PATCH 1/2] block: Move general unplug callback function
> from md/raid to blk-core
> 
> 2012/6/5  <Tao.Guo@emc.com>:
> > If you ever tried to implement unplug function in umem, you would
> find the code was almost identical as in dm/raid driver.
> > For other components which also need such unplug mechanism, it will
> much more convenient to have such facilities.
> It's just several lines of code and your usage actually doesn't need
> the counter.
> It's unclear to me your usage requires to move the callback to list
> head.
> 
> > PS: What's your specific concern about blk_plug_cb handles each
> request_queue?
> the blk_plug_cb stores request_queue, which is incorrect to me. Why
> can't
> one plug cb unplug two or more request_queues?

