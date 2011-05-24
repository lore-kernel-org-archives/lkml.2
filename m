Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751919Ab1EXEod (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 00:44:33 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:55849 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751303Ab1EXEoc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 00:44:32 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=c3JctvdrLEO/lSko5Mq6D9UGRSHJwCyAuUhbKL5hIg3ejln8e3aM5Sfs0k49VTYf7kKrP7uSY3HsDYCTTH3pHC0reV8+YZsWcUbAnKVfFMQ5BpDh+kRGcCCvbT7NWOvI;
Date: Mon, 23 May 2011 21:44:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mike Frysinger <vapier@gentoo.org>
Cc: Valdis.Kletnieks@vt.edu, Joe Perches <joe@perches.com>,
        anish singh <anish198519851985@gmail.com>, davej@redhat.com,
        rostedt@goodmis.org, apw@shadowen.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, man.k1983@gmail.com
Subject: Re: [patch v3] checkpatch: Signature format verification
Message-Id: <20110523214427.7d348c44.rdunlap@xenotime.net>
In-Reply-To: <BANLkTinwGhs0OaH7gZsyrbmL-6wMcmM2VA@mail.gmail.com>
References: <1306006721.1622.18.camel@anish-desktop>
	<1306059528.2761.3.camel@anish-desktop>
	<1306164094.2292.25.camel@anish-desktop>
	<1306167105.8687.11.camel@Joe-Laptop>
	<BANLkTi=9nzMbxU0=P+pOaHcebqhL=bd2HQ@mail.gmail.com>
	<1306168598.8687.27.camel@Joe-Laptop>
	<20110523093920.8f1e5cd0.rdunlap@xenotime.net>
	<1306168975.8687.29.camel@Joe-Laptop>
	<BANLkTik8coVxt=Z92NQBNH_=4yRhTtexzA@mail.gmail.com>
	<1306171117.8687.34.camel@Joe-Laptop>
	<BANLkTikqezyJMy1_i-woTVM9bvVL750iew@mail.gmail.com>
	<1306174166.8687.49.camel@Joe-Laptop>
	<BANLkTimCZP0raacMazU7wWTtoAUcUE9vRQ@mail.gmail.com>
	<5210.1306200244@localhost>
	<BANLkTinwGhs0OaH7gZsyrbmL-6wMcmM2VA@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011 21:31:29 -0400 Mike Frysinger wrote:

> On Mon, May 23, 2011 at 21:24,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Mon, 23 May 2011 18:51:42 EDT, Mike Frysinger said:
> >> On Mon, May 23, 2011 at 14:09, Joe Perches wrote:
> >> >    167     Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> >>
> >> personally, i dont think those quotes should be there
> >
> > Although not strictly required by the ABNF of RFC822 and its successors, it's
> > probably a wise thing to apply the double quotes in this case anyhow, due to
> > the fairly high likelyhood that some software will choke on the ' character in
> > Ted's last name if unquoted.
> 
> then people will notice their software blows and they'll fix it
> 
> i dont have a problem with "over" quoting with the From/To/CC headers
> in say `git format-patch` or `git send-email`, but i dont think they
> make sense in s-o-b/related tags.

They certainly facilitate copy-and-paste at least.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
