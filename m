Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab2EaTZp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:25:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:49652 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933116Ab2EaTZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:25:43 -0400
Message-ID: <1338492342.5861.23.camel@joe2Laptop>
Subject: Re: [GIT PULL] new mailmap file for the linux kernel git repository
From: Joe Perches <joe@perches.com>
To: Philipp Riemer <ruderphilipp@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jiri Kosina <jkosina@suse.cz>,
        Paul Mundt <lethal@linux-sh.org>,
        Michael =?ISO-8859-1?Q?B=FCsch?= <m@bues.ch>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Wang Chen <ellre923@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 31 May 2012 12:25:42 -0700
In-Reply-To: <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com>
References: <CAFU-uVs_Gwacxj74cyekY2gv+zAq+Spba7nfPLdTc_dR3y8CYw@mail.gmail.com>
	 <20120516143830.GA483@kroah.com>
	 <alpine.LNX.2.00.1205161640520.8796@pobox.suse.cz>
	 <CAFU-uVt94sgzq7DgsgKL2OJ0e7DazvNpFunx7BNEz88LHJOg+g@mail.gmail.com>
	 <20120516150813.GA3293@kroah.com>
	 <CAFU-uVvzyN0asmReOVJcAEiAtbQ=styfGxRRbnrJKgNFDS5X_g@mail.gmail.com>
	 <CAFU-uVsStG0KoiQm95-uC8ZPXWAq=8Q8vXircxOuUCHhk+r9uw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-31 at 18:08 +0200, Philipp Riemer wrote:
> updated mailmap file for LK repository
> 
> The current version of the .mailmap file does only capture a fraction of errors
> and ambiguity when looking at developers emails and names. Hence, this revised
> version tries to address many more names and, as a result, to clarify maintainer
> information. Issues addressed:
>  - Typos in names
>  - Typos in mails
>  - Mapping of ambiguous mail adresses (e.g. {aa@bb.cc, aa@home.(none),
>    aa@laptop.bb.cc,...} becomes {aa@bb.cc}) but keeping LKML specific ones
>  - Mapping of names to entries with only email information
>  - Correct usage of special character (e.g. German umlauts)
>  - Harmonization of position and style of last name (no more all-caps names
>    like "First LAST" or those of "Last, First")
>  - No initials in names if not necessary

Removing initials is probably not a good idea.

>  - Conversion of email addresses to lower case
> 
> Signed-off-by: Philipp Riemer <ruderphilipp@gmail.com>
> ---
> Finally I am back from my trip through Germany and after attending
> LinuxTag in Berlin last week, reading Documentation/SubmittingPatches,
> and checking other patch submissions, I give this topic finally a new
> try...  Hopefully my submission confirms to the LK standards this
> time. I can certify that this contribution was conscientiously created
> in whole by me and therefore added the sign-off message.
> 
> Please pull from
> 
> 		git://github.com/ruderphilipp/linux.git mailmap-changes
> 
> to get the changes in the attached patch file (since even the
> web-interface of GMail wraps lines) -- or simply inspect/apply that
> file directly.
> 
> $ git diffstat upstream/master..origin/mailmap-changes .mailmap
>  .mailmap | 2482 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 2444 insertions(+), 38 deletions(-)
> 

I'm still not sure this is really necessary.

It's pretty big and would need continual ongoing
maintenance for what seems to me relatively little
value.

Maybe you can diff the git shortlog before and after
this patch and determine if this is really useful.

Also, some of these entries look odd at first glance:

+Adam Brooks <adam.j.brooks@gmail.com>                   <From: jiang.adam@gmail.com>

Is that the same person?

-Al Viro <viro@ftp.linux.org.uk>
-Al Viro <viro@zenIV.linux.org.uk>
[]
+Alexander Viro <viro@ftp.linux.org.uk>

I think I've never seen that name before.

I stopped looking at the patch after that.

I ran a git shortlog -n -s before and after
your patch and I'm a bit confused by the
result.

Some people seem to be missing altogether.
	(Avi Kivity, etc...)
Some people have _fewer_ commits.
	(Andrew Morton, etc...)

Any idea why?

Here's just the start, it's a long diff

--- shortlog.ns.old	2012-05-31 12:08:12.776091892 -0700
+++ shortlog.ns.new	2012-05-31 12:07:55.596091644 -0700
@@ -1,262 +1,260 @@
  12313	Linus Torvalds
-  4232	David S. Miller
+  4383	David Miller
   3627	Takashi Iwai
-  3566	Ingo Molnar
-  3208	Al Viro
+  3568	Ingo Molnar
+  3211	Alexander Viro
+  2874	Russell King
   2860	Mark Brown
-  2770	Russell King
   2491	Tejun Heo
   2461	Paul Mundt
-  2376	Thomas Gleixner
-  2363	Greg Kroah-Hartman
+  2378	Thomas Gleixner
+  2368	Greg Kroah-Hartman
   2282	Mauro Carvalho Chehab
   2245	Johannes Berg
   2063	Bartlomiej Zolnierkiewicz
+  1947	Stephen Hemminger
   1924	Adrian Bunk
   1817	Alan Cox
   1813	Christoph Hellwig
   1727	Ralf Baechle
-  1672	Stephen Hemminger
-  1619	Joe Perches
-  1558	Andrew Morton
-  1545	Randy Dunlap
+  1625	Joe Perches
+  1558	Randy Dunlap
+  1557	Andrew Morton
   1473	Eric Dumazet
   1466	Jean Delvare
   1463	Hans Verkuil
   1434	Trond Myklebust
-  1364	Ben Dooks
+  1368	Ben Dooks
   1337	Jeff Garzik
   1322	Andi Kleen
   1309	Peter Zijlstra
-  1270	Patrick McHardy
+  1271	Patrick McHardy
   1237	Steven Rostedt
   1222	Arnaldo Carvalho de Melo
   1209	Axel Lin
-  1168	Mike Frysinger
+  1168	Michael Frysinger
   1155	Benjamin Herrenschmidt
-  1147	NeilBrown
+  1100	Neil Brown
   1093	David Woodhouse
   1057	Dan Carpenter
   1048	Herbert Xu
   1028	Magnus Damm
   1019	Jiri Slaby
-  1009	Avi Kivity
   1006	Yinghai Lu
    991	Alexey Dobriyan
    987	Arnd Bergmann
    979	Chris Mason
    979	Dmitry Torokhov
-   972	Len Brown
+   974	Len Brown
    962	Michael Krufky
    953	Julia Lawall
    948	David Howells
-   945	Rafael J. Wysocki
+   948	Rafael Wysocki
    928	Jens Axboe
    918	Alan Stern
    914	Dave Airlie
    908	Jeremy Fitzhardinge
    904	David Brownell
-   898	Heiko Carstens
+   899	Heiko Carstens
    885	Chris Wilson
    876	Ben Skeggs
-   857	Alex Deucher
+   857	Alexander Deucher
    856	Ben Hutchings
-   847	Stephen Rothwell
+   848	Stephen Rothwell
+   838	Eric Biederman
    837	Sam Ravnborg
-   830	Eric W. Biederman
+   813	Artem Bityutskiy
    811	Dan Williams
    807	Rusty Russell
-   787	Joerg Roedel
+   789	Jörg Rödel
    777	Paul Mackerras
-   774	Stefan Richter
-   767	FUJITA Tomonori
-   765	Uwe Kleine-König
-   760	John W. Linville
-   759	Roland Dreier
-   753	Artem Bityutskiy
+   777	Stefan Richter
+   771	Uwe Kleine-König
+   768	Tomonori Fujita
+   761	John Linville
+   760	Roland Dreier
    750	Kumar Gala
-   739	Steve French
+   738	Steve French
    734	Lennert Buytenhek
-   731	Luis R. Rodriguez
    727	Clemens Ladisch
-   725	Christoph Lameter
+   726	Christoph Lameter
+   722	J. Bruce Fields
    721	Oleg Nesterov
-   719	J. Bruce Fields
    717	Chuck Lever
+   716	Luis Rodriguez
    711	Guennadi Liakhovetski
+   711	Roel Kluin
    705	Greg Ungerer
    700	Steven Whitehouse
-   695	Bjorn Helgaas
+   698	Bjorn Helgaas
    686	Wey-Yi Guy
    685	Pavel Emelyanov
    680	Jesper Juhl
    678	Harvey Harrison
-   673	Larry Finger
+   676	Larry Finger
+   667	Jean-François Moine
...

