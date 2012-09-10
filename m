Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757991Ab2IJXBG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:01:06 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:64789 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757342Ab2IJXBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:01:03 -0400
MIME-Version: 1.0
In-Reply-To: <20120910225057.GA10477@agk-dp.fab.redhat.com>
References: <1347055973-11581-3-git-send-email-koverstreet@google.com>
	<20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120910002810.GA23241@moria.home.lan>
	<20120910172210.GC14103@google.com>
	<20120910202435.GG16360@google.com>
	<20120910204010.GA32310@google.com>
	<20120910213349.GH16360@google.com>
	<20120910213710.GA7677@google.com>
	<20120910215633.GA19739@google.com>
	<20120910220910.GB7677@google.com>
	<20120910225057.GA10477@agk-dp.fab.redhat.com>
Date: Mon, 10 Sep 2012 16:01:01 -0700
X-Google-Sender-Auth: C9VBACtD6AwvLt3284zSepb5KOw
Message-ID: <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio allocation
 by stacking drivers
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        device-mapper development <dm-devel@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 10, 2012 at 3:50 PM, Alasdair G Kergon <agk@redhat.com> wrote:
>> >     Note that this doesn't do anything for allocation from other mempools.
>
> Note that dm has several cases of this, so this patch should not be used with
> dm yet.  Mikulas is studying those cases to see whether anything like this
> might be feasible/sensible or not.

IIUC, Kent posted a patch which converts all of them to use front-pad
(there's no reason not to, really). This better come after that but
it's not like this is gonna break something which isn't broken now.

Thanks.

-- 
tejun
