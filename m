Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2JVQB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:01:58 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:51183 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JVQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:01:57 -0400
MIME-Version: 1.0
In-Reply-To: <20121022154258.GB9438@quack.suse.cz>
References: <CADpTngUPcX71qjE2QKhYqgDg7tZoz+pu8A6nE9DT-zbFKWGx1g@mail.gmail.com>
	<20121018212357.GA17646@quack.suse.cz>
	<1350596425.1366.15.camel@x61.thuisdomein>
	<20121018220809.GD17646@quack.suse.cz>
	<20121019124454.316ecfac@notabene.brown>
	<CADpTngX=6vWV1fv8x-g8ufKTb3gW2=phPZBHZJHATEcqqjwtYg@mail.gmail.com>
	<CADpTngVnJwmu-E3wJwUaK2CKGBsRoJphRNtDPAO9AHyOnnfeRQ@mail.gmail.com>
	<20121022134541.GA9438@quack.suse.cz>
	<CADpTngX9YNq6Own1gvrHnwizUfG0KfjRuXL2F38n2C+CnOTpDA@mail.gmail.com>
	<20121022154258.GB9438@quack.suse.cz>
Date: Mon, 22 Oct 2012 18:01:56 +0200
Message-ID: <CADpTngUxFT+Sj1aZDY3iBMLpwgrj5rziTSibWD3HMC_DszZpDw@mail.gmail.com>
Subject: Re: ext3 issue on 3.6.1
From: Fabio Coatti <fabio.coatti@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: NeilBrown <neilb@suse.de>, "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/22 Jan Kara <jack@suse.cz>:
>> Uhu, my fault, I was sure to have answered to your request, sorry.
>> So yes, we have an ext3 R/O partition mounted on that machine. The
>> 3.6.3, with patch applied, dmesg is here:
>   Interesting. You seem to be using data=journal on R/O partition, don't
> you? Can you also attach /proc/mounts?
>
>   Also please try running a kernel with the attached patch and report the
> warning. Thanks!

Do you want to try the kernel without touching the mount
configuration, right? (I mean, without (say) mounting ext2 the ext3 ro
partition, right?)
right now I can't access the machine, but I recall that the partition
is mounted rw, something is wrote onto it and then changed to r/o and
among the options there is data=ordered.

I'll run your patch asap, many thanks for the answer.


-- 
Fabio
