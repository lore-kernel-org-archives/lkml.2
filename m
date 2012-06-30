Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124Ab2F3Aho (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 20:37:44 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56969 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab2F3Ahn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 20:37:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120629230237.GF21048@google.com>
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
Date: Fri, 29 Jun 2012 19:37:42 -0500
Message-ID: <CAKA=qzZVVvhjw4gxxAcaDG1e0Lxwf7ROTm1XgXhavgMAExrAVg@mail.gmail.com>
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

On Fri, Jun 29, 2012 at 6:02 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Josh.
>
> Can you please test the followign patch?  It's on top of 3.5-rc4.  It
> seems to work here but is still quite experimental and may cause
> crashes or alien invasion especially across cpu hotplugs.
>
> Thanks.
>
Wow. Thanks Tejun. I will try and get to this over the weekend, but it
may not be until Monday before I can test it.

-- 
Josh
