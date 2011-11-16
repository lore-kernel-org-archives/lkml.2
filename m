Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab1KPMuV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:50:21 -0500
Received: from esgaroth.petrovitsch.at ([78.47.184.11]:1127 "EHLO
	esgaroth.petrovitsch.priv.at" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753068Ab1KPMuT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:50:19 -0500
X-DKIM: Sendmail DKIM Filter v2.8.3 unknown-host pAGCo9F8018142
Subject: Re: Documentation/input/input.txt.gz has a bug
From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: jidanni@jidanni.org, linux-kernel@vger.kernel.org
Date: Wed, 16 Nov 2011 13:50:10 +0100
In-Reply-To: <4EC2BEF6.7070906@xenotime.net>
References: <8762im2n5f.fsf@jidanni.org> <4EC2BEF6.7070906@xenotime.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1321447814.22548.18.camel@thorin>
Mime-Version: 1.0
X-DCC-x.dcc-servers-Metrics: esgaroth.petrovitsch.priv.at; whitelist
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Die, 2011-11-15 at 11:35 -0800, Randy Dunlap wrote:
[...]
>   Doing a "cat /dev/input/mouse0" (char device 13,32) will verify that
> a mouse is also emulated; characters should appear if you move it.
>   Doing a
> $ cat /dev/input/mouse

Hmm, how is this written in the other documentation?

Both are fine with me. FWIW in emails and the like, I use backquotes
usually as in
----  snip  ----
Doing a `cat /dev/input/mouse0` (char device 13,32) will verify that
a mouse is also emulated; characters should appear if you move it.
----  snip  ----

	Bernd
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at

