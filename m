Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756788Ab2FONd5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 09:33:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41859 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab2FONdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:33:55 -0400
MIME-Version: 1.0
In-Reply-To: <20120615111913.GA13539@mwanda>
References: <20120614172523.GB4400@mwanda>
	<20120615014835.GA5695@localhost>
	<20120615071222.GZ13539@mwanda>
	<20120615075810.GA13206@localhost>
	<alpine.DEB.2.02.1206150639130.1864@hadrien>
	<20120615111913.GA13539@mwanda>
Date: Fri, 15 Jun 2012 10:33:50 -0300
Message-ID: <CA+MoWDrKJwiK66zpBxQ=q+qS7n_P4qLySgBRdj2txq20wa7bvA@mail.gmail.com>
Subject: Re: automated warning notifications
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Fengguang Wu <wfg@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Pekka Enberg <penberg@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@freedesktop.org>,
        Linus Torvalds <torvalds@ppc970.osdl.org>
Content-Type: multipart/mixed; boundary=f46d04428756db45f104c282ddae
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f46d04428756db45f104c282ddae
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Added git-blame support...

On Fri, Jun 15, 2012 at 8:19 AM, Dan Carpenter <dan.carpenter@oracle.com> w=
rote:
> On Fri, Jun 15, 2012 at 06:40:51AM -0400, Julia Lawall wrote:
>> > > Eventually I think we will want to set up a mailing list for this or
>> > > we will start sending duplicate messages.
>> >
>> > Fair enough. How can we setup the mailing list? Once the list up, it
>> > would be trivial for me to send sparse warnings out there.
>>
>> I'm not completely sure that a mailing list would completely eliminate
>> duplicate messages. =A0But still, it could be the place for people who a=
re
>> interested in seeing such messages to go to, so it seems like a good
>> thing. =A0I would be happy to contribute content :)
>
> Yeah. =A0That might be interesting. =A0If you don't know whether a bug
> is a false positive or not you could submit it to the list for
> people to look at.
>
> I don't know if anyone will actually look at them. =A0I had been
> planning to filter them to a mail box and automatically ignore
> anything that was a duplicate. =A0But it might actually be worth
> looking at them as well. =A0Especially if you email had enough useful
> context so I could tell from the message what the bug is.
>
> Probably we could use something like the attached script to print
> out the line of code which causes the bug and some other script to
> querry git blame and attach the offending commit?
>
> regards,
> dan carpenter
>



--=20
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36

--f46d04428756db45f104c282ddae
Content-Type: application/x-sh; name="context2.sh"
Content-Disposition: attachment; filename="context2.sh"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_h3haso1g1

IyEvYmluL2Jhc2gKCmZ1bmN0aW9uIHVzYWdlCnsKICAgIGVjaG8gIlVzYWdlICQwIDxmaWxlIG5h
bWU+IDxsaW5lPiA8Y29udGV4dD4iCiAgICBleGl0IDEKfQoKY29kZV9maWxlPSQxCmxpbmVubz0k
Mgpjb250ZXh0PSQzCgoKaWYgWyAiJGxpbmVubyIgPSAiIiBdIDsgdGhlbgogICAgdXNhZ2UKZmkK
CmlmIFsgIiRjb250ZXh0IiA9ICIiIF0gOyB0aGVuCiAgICBjb250ZXh0PTYKZmkKCmlmIFsgIiRj
b250ZXh0IiAtbHQgIjQiIF0gOyB0aGVuCiAgIGNvbnRleHQ9NApmaQoKaWYgWyAkKCgkY29udGV4
dCAlIDIgKSkgIT0gIjAiIF0gOyB0aGVuCgljb250ZXh0PSQoKCRjb250ZXh0ICsgMSkpCmZpCgpz
dGFydF9saW5lPSQoKCRsaW5lbm8gLSAoJGNvbnRleHQgLyAyKSkpCmVuZF9saW5lPSQoKCRsaW5l
bm8gKyAoJGNvbnRleHQgLyAyKSkpCgpjYXQgLW4gJGNvZGVfZmlsZSB8IHRhaWwgLW4gKyRzdGFy
dF9saW5lIHwgaGVhZCAtbiAkKCgkY29udGV4dCArIDEpKQoKZWNobwplY2hvIC0tLQplY2hvCgpn
aXQgYmxhbWUgJGNvZGVfZmlsZSAtTCAkc3RhcnRfbGluZSwkZW5kX2xpbmUK
--f46d04428756db45f104c282ddae--
