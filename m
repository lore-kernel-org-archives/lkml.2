Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2F0R7r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:59:47 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:50228 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab2F0R7q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:59:46 -0400
MIME-Version: 1.0
In-Reply-To: <20120627175458.GL15811@google.com>
References: <20120626125953.GA22557@redhat.com>
	<CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
	<20120626155332.GJ22557@redhat.com>
	<CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
	<20120626205651.GW3869@google.com>
	<CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
	<CAKA=qzaZweeeYUFD2OHDeAO-SQihSvExAZ=ZnXeY5o5sMWpxJg@mail.gmail.com>
	<CAKA=qzbaM-z7CbASUgq-A7CZWiUq6pdb93e4giYAw63hQK=MCg@mail.gmail.com>
	<20120627173822.GK15811@google.com>
	<CAKA=qzY5FT8rWU=z8DwGB7aF6AvCuT=bH2sOJQafyEPqtbkduQ@mail.gmail.com>
	<20120627175458.GL15811@google.com>
Date: Wed, 27 Jun 2012 12:59:45 -0500
Message-ID: <CAKA=qzaArsuwuuqHVKgTqwszY_Zx8d690e6UJsOQUvq_4--hjQ@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Josh Hunt <joshhunt00@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2012 at 12:54 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Jun 27, 2012 at 12:44:04PM -0500, Josh Hunt wrote:
>> Awesome, thanks!
>
> One question tho.  The system was pretty heavily loaded (CPU-wise)
> when the hiccup happened, right?
>
> Thanks.
>
> --
> tejun

The particular machines I've been testing on are dual-core and at
least one of the cores is pretty heavily loaded, on avg 10-15% idle.
Sometimes it gets pegged out. The other core is moderately loaded.
Usually around 30-40% idle.

-- 
Josh
