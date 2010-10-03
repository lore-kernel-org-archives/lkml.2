Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201Ab0JCRS1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 13:18:27 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:58043 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030Ab0JCRS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 13:18:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=BE88WH5TXn11jLzvbZwC9EW00XlPcro6mMrjVhci6Pq9YqOce5qUk3snMGXIdjJfng
         FzgPhSaDHoJdsxrmxGxFGnxLKM3TsR0D2FkWiVRQZGmUsRShWOb91Z02xcp5FAYKvJIU
         tCrItLk6xRhDDlRivEM9xf+x/BTmkMbBQ816s=
Date: Sun, 3 Oct 2010 13:18:23 -0400
From: tmhikaru@gmail.com
To: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later
Message-ID: <20101003171823.GA19129@roll>
References: <20101001035321.GA2360@roll> <20101001094814.GA5029@roll> <20101003030254.GA4901@roll> <1286095268.2144.119.camel@laptop> <20101003121209.586f7b6b@schatten.dmk.lab> <1286107478.2144.177.camel@laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2oS5YaxWCcQjTEyO"
Content-Disposition: inline
In-Reply-To: <1286107478.2144.177.camel@laptop>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2oS5YaxWCcQjTEyO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I screwed up and sent this incorrectly to only Peter originally, resent to
everyone else too.

On Sun, Oct 03, 2010 at 02:04:38PM +0200, Peter Zijlstra wrote:
> On Sun, 2010-10-03 at 12:12 +0200, Florian Mickler wrote:
> > On Sun, 03 Oct 2010 10:41:08 +0200
> > Peter Zijlstra <peterz@infradead.org> wrote:
> >
> > > On Sat, 2010-10-02 at 23:02 -0400, tmhikaru@gmail.com wrote:
> > > >  The load average statistic is indeed broken somehow, and I
> > > > did bisect it down to where the problem began, however there seems
> > > >  to be no
> > > > performance problem related to it I can find.
> > >
> > > Chase, anything you can see broken with this stuff?
> >
> > Peter, do you think it would be worthwile to test a kernel with the
> > low load-averages in NOHZ=disable mode? The bisected commit claims to
> > fix a NOHZ issue with the load average. So if the new figures are the
> > correct ones, they should be somehow similar to the figures before
> > with NOHZ? Or am I on the wrong track here?
>
> No, that makes sense, but there is of course the distinct possibility
> that the patch wrecked the !nohz path as well. So ideally you'd have to
> compare NOHZ=n with this patch reverted and NOHZ=y with this patch in
> place.
>

That'd be easy for me to do if you want. given I use CONFIG_NO_HZ=y
in my kernel .config, that's tested the 'patch already in place' path right?
I'll try setting up a kernel build with CONFIG_NO_HZ=n if that's what you
want me to test. I unfortunately am not entirely sure if that's what I need
to alter though, so please get back to me and let me know so I can test it.

Tim McGrath

--2oS5YaxWCcQjTEyO
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTKi635EncCrqzVruAQLS2wf/UDZ1s3XzMz2O1GfeqiM5YJgviPRTR/ja
goyWqzsLcM3xoyIMKUZo6/ISdWBcTzG3XXsQfA7v8BekqQAZGnEHDM3+cSVyiQk9
z03ObDtRmFza1mNpYVH44sH1jV8qUdY8FMxEHStokCM/B2ca28y+E1LwW4PnFWmA
d2qbUzPbDmWLHvix8o2TOPYrR2dLyDnobClXAq2HdE6dN6q69VQmElCr1RurO49f
dJM5hU68M+/0viEsTINZfaC5dlrYleuEvaInIum7a8rr2a7FwFimbdT7boWmf8c5
TxkDOk5gxLPj6pexocOQ/QGk6189G1HN4jZpRcZa4hdZUxVAJkyelQ==
=MPdN
-----END PGP SIGNATURE-----

--2oS5YaxWCcQjTEyO--
