Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab2F0RoG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 13:44:06 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:37179 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2F0RoE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 13:44:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120627173822.GK15811@google.com>
References: <CAKA=qzaU=wKLrprgJ4z32tqqyO6W0+SBcaV=ArWAdKh_9c=Zew@mail.gmail.com>
	<CAKA=qzY+J-Ab8NC-+r1Dw_-giVzC=z8SnxJhSWHF-ud8j3yg6A@mail.gmail.com>
	<20120626125953.GA22557@redhat.com>
	<CAKA=qzZ_KhRbH6F4-TWvSAWiJyDsDrz4oUO5WppoMgWNEhyZmg@mail.gmail.com>
	<20120626155332.GJ22557@redhat.com>
	<CAKA=qzYoX-1nTZ6QfdD7RhWf=KU7J6tWOJXgt-F+Kz2c3Xn0TQ@mail.gmail.com>
	<20120626205651.GW3869@google.com>
	<CAKA=qzbBtteDjHiPogCvN5jOSiPrDxx=vn96p02bXUy=6=jAgA@mail.gmail.com>
	<CAKA=qzaZweeeYUFD2OHDeAO-SQihSvExAZ=ZnXeY5o5sMWpxJg@mail.gmail.com>
	<CAKA=qzbaM-z7CbASUgq-A7CZWiUq6pdb93e4giYAw63hQK=MCg@mail.gmail.com>
	<20120627173822.GK15811@google.com>
Date: Wed, 27 Jun 2012 12:44:04 -0500
Message-ID: <CAKA=qzY5FT8rWU=z8DwGB7aF6AvCuT=bH2sOJQafyEPqtbkduQ@mail.gmail.com>
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

On Wed, Jun 27, 2012 at 12:38 PM, Tejun Heo <tj@kernel.org> wrote:
> On Wed, Jun 27, 2012 at 12:21:32PM -0500, Josh Hunt wrote:
>> Was wondering if you had any suggestions on further instrumentation or
>> more data that you may need to better understand the problem?
>
> I think it's caused by the lazy HIGHPRI implementation in wq.  Working
> on it now.
>
> Thanks.
>
> --
> tejun

Awesome, thanks!

-- 
Josh
