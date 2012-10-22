Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618Ab2JVQKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:10:43 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755543Ab2JVQKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:10:42 -0400
Date: Mon, 22 Oct 2012 18:10:40 +0200
From: Jan Kara <jack@suse.cz>
To: Fabio Coatti <fabio.coatti@gmail.com>
Cc: Jan Kara <jack@suse.cz>, NeilBrown <neilb@suse.de>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        Paul Bolle <pebolle@tiscali.nl>, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: Re: ext3 issue on 3.6.1
Message-ID: <20121022161040.GC9438@quack.suse.cz>
References: <20121018212357.GA17646@quack.suse.cz>
 <1350596425.1366.15.camel@x61.thuisdomein>
 <20121018220809.GD17646@quack.suse.cz>
 <20121019124454.316ecfac@notabene.brown>
 <CADpTngX=6vWV1fv8x-g8ufKTb3gW2=phPZBHZJHATEcqqjwtYg@mail.gmail.com>
 <CADpTngVnJwmu-E3wJwUaK2CKGBsRoJphRNtDPAO9AHyOnnfeRQ@mail.gmail.com>
 <20121022134541.GA9438@quack.suse.cz>
 <CADpTngX9YNq6Own1gvrHnwizUfG0KfjRuXL2F38n2C+CnOTpDA@mail.gmail.com>
 <20121022154258.GB9438@quack.suse.cz>
 <CADpTngUxFT+Sj1aZDY3iBMLpwgrj5rziTSibWD3HMC_DszZpDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADpTngUxFT+Sj1aZDY3iBMLpwgrj5rziTSibWD3HMC_DszZpDw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 22-10-12 18:01:56, Fabio Coatti wrote:
> 2012/10/22 Jan Kara <jack@suse.cz>:
> >> Uhu, my fault, I was sure to have answered to your request, sorry.
> >> So yes, we have an ext3 R/O partition mounted on that machine. The
> >> 3.6.3, with patch applied, dmesg is here:
> >   Interesting. You seem to be using data=journal on R/O partition, don't
> > you? Can you also attach /proc/mounts?
> >
> >   Also please try running a kernel with the attached patch and report the
> > warning. Thanks!
> 
> Do you want to try the kernel without touching the mount
> configuration, right? (I mean, without (say) mounting ext2 the ext3 ro
> partition, right?)
  Yes, leave things as they are now...

> right now I can't access the machine, but I recall that the partition
> is mounted rw, something is wrote onto it and then changed to r/o and
> among the options there is data=ordered.
  /proc/mounts should show us whether data=ordered is in use. Actually the
warning is in function which is called only in data=journal mode so that's
why I think you are using it...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
