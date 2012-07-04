Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249Ab2GDBNB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 21:13:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57077 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab2GDBNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 21:13:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAKA=qzZVVvhjw4gxxAcaDG1e0Lxwf7ROTm1XgXhavgMAExrAVg@mail.gmail.com>
References: <20120626155332.GJ22557@redhat.com>
	<CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
	<20120626205651.GW3869@google.com>
	<CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
	<CAKA=qzaZweeeYUFD2OHDeAO-SQihSvExAZ=ZnXeY5o5sMWpxJg@mail.gmail.com>
	<CAKA=qzbaM-z7CbASUgq-A7CZWiUq6pdb93e4giYAw63hQK=MCg@mail.gmail.com>
	<20120627173822.GK15811@google.com>
	<CAKA=qzY5FT8rWU=z8DwGB7aF6AvCuT=bH2sOJQafyEPqtbkduQ@mail.gmail.com>
	<20120627175458.GL15811@google.com>
	<CAKA=qzaArsuwuuqHVKgTqwszY_Zx8d690e6UJsOQUvq_4--hjQ@mail.gmail.com>
	<20120629230237.GF21048@google.com>
	<CAKA=qzZVVvhjw4gxxAcaDG1e0Lxwf7ROTm1XgXhavgMAExrAVg@mail.gmail.com>
Date: Tue, 3 Jul 2012 18:12:58 -0700
X-Google-Sender-Auth: GYlPI_MXqDasv7C0-heEzoPsNhc
Message-ID: <CAOS58YO5oDn9Y=2dPiDPQ8u4kk7ewV2GLfMDZnjnaazkv+N-0w@mail.gmail.com>
Subject: Re: multi-second application stall in open()
From: Tejun Heo <tj@kernel.org>
To: Josh Hunt <joshhunt00@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Jun 29, 2012 at 5:37 PM, Josh Hunt <joshhunt00@gmail.com> wrote:
> Wow. Thanks Tejun. I will try and get to this over the weekend, but it
> may not be until Monday before I can test it.

Any progress?

Thanks!

-- 
tejun
