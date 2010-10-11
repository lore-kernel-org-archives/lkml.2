Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab0JKJg6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:36:58 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:38609 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab0JKJg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:36:57 -0400
Subject: get_maintainer
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 11 Oct 2010 11:36:55 +0200
Message-ID: <1286789815.3634.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe,

get_maintainer.pl has a huge amount of false positives, and as a net
result people CC me on *all* wireless driver patches (when they use the
script) because I've touched them all in commits like 97359d1235eaf634f.

Would it be possible to modify the script to actually look at the
patches it found and not CC people if the changes to the file in
question are, say, less than 20% of the overall patch?

If that turns out to not be possible, I think I'm going to have to cook
up blacklist support for it ... :-)

johannes

