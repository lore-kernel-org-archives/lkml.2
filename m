Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932904Ab0LHBEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 20:04:08 -0500
Received: from kroah.org ([198.145.64.141]:33870 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932599Ab0LHBEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 20:04:01 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:48 2010
Message-Id: <20101208005748.343822832@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 17:00:46 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Michal Marek <mmarek@suse.cz>
Subject: [269/289] kbuild: use getopt_long(), not its _only() variant
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Arnaud Lacombe <lacombar@gmail.com>

commit c94d3fb01fb6db1899cdf53ea4eb9d38e08a08fe upstream.

NetBSD lacks getopt_long_only() whereas getopt_long() works just fine.

Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Michal Marek <mmarek@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 scripts/kconfig/conf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -466,7 +466,7 @@ int main(int ac, char **av)
 	bindtextdomain(PACKAGE, LOCALEDIR);
 	textdomain(PACKAGE);
 
-	while ((opt = getopt_long_only(ac, av, "", long_opts, NULL)) != -1) {
+	while ((opt = getopt_long(ac, av, "", long_opts, NULL)) != -1) {
 		input_mode = (enum input_mode)opt;
 		switch (opt) {
 		case silentoldconfig:


