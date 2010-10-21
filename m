Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756658Ab0JUBst (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 21:48:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:62616 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753002Ab0JUBss (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 21:48:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eEiF4RD5ltjy66qQ3fF7UtSpLrlAOpwOwCzRhRtcqlbm/q70p19VYp0QS357GbhCFI
         AP5Qj3Q3rYorVekDmaw7EiH66dncnzoRdvsA3V0CiFLRvJYpOQ8CkFelGkqCT/39tOsB
         aphQapvdBmKCwtY6uHhZP3/yNI01SzooaIf4o=
Date: Wed, 20 Oct 2010 21:48:43 -0400
From: tmhikaru@gmail.com
To: Peter Zijlstra <peterz@infradead.org>, Damien Wyart <damien.wyart@free.fr>,
        Chase Douglas <chase.douglas@canonical.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Venkatesh Pallipadi <venki@google.com>
Subject: Re: High CPU load when machine is idle (related to PROBLEM: Unusually high load average when idle in 2.6.35, 2.6.35.1 and later)
Message-ID: <20101021014843.GA21295@roll>
References: <20100929070153.GA2200@brouette> <20101014145813.GA2185@brouette> <20101020132732.GA30024@brouette> <1287581440.3488.16.camel@twins> <1287582208.3488.20.camel@twins> <1287584073.3488.22.camel@twins> <1287595605.3488.52.camel@twins>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <1287595605.3488.52.camel@twins>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 20, 2010 at 07:26:45PM +0200, Peter Zijlstra wrote:
>=20
>=20
> OK, how does this work for people? I find my idle load is still a tad
> high, but maybe I'm not patient enough.

I haven't had a chance to keep up with the topic, and I apologize. I'll be
testing this as soon as I can finish compiling it. Thank you all for not
letting this go unfixed.

Tim McGrath
--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUBTL+b+5EncCrqzVruAQIb8Qf+LAwxg3R8yezfe3bNvXUYIIcqgi0KjGN1
RCZw2vMo8BONvF4xk2qFf0vx6gxxv0e0T4sqMIoGcP9OALBZtbXRxXHlx/R1lIgp
IWML7YxCg4XicYJP6la7URSE4EXf4mPDswMSo0Uvxkdek4989eU32WDCv7oZdA9h
5uFedPfFuM+O5gcEoYWIVKlrVSPZJimVVbB+9YEX+cyxr1tPQ8Owy74ikRGWBFBf
Dng1UTSVbeYA6IzVDmqfIZFjdRgzKQMLKxJwJMjfL69OcULL9eYvYd5ldJsgaA0z
42XXcVwYBunjdOsPLwnTqEQNVbsd26M2HAeb9bOEjVcNp42kw70fcA==
=liag
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
