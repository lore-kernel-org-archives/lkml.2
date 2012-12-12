Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2LLV5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 16:57:11 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:45915 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2LLV5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 16:57:09 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 12 Dec 2012 22:56:59 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] MAINTAINERS: adjust for UAPI: firewire
Message-ID: <20121212225659.7db664fd@stein>
In-Reply-To: <1355262601-4263-8-git-send-email-cesarb@cesarb.net>
References: <1355262601-4263-1-git-send-email-cesarb@cesarb.net>
	<1355262601-4263-8-git-send-email-cesarb@cesarb.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 386fce6..9722918 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3071,7 +3071,8 @@ W:	http://ieee1394.wiki.kernel.org/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/ieee1394/linux1394.git
 S:	Maintained
 F:	drivers/firewire/
-F:	include/linux/firewire*.h
+F:	include/linux/firewire.h
+F:	include/uapi/linux/firewire*.h
 F:	tools/firewire/
 
 FIRMWARE LOADER (request_firmware)
-- 

On Dec 11 Cesar Eduardo Barros wrote:
> Several headers were moved or split to uapi/.
> 
> Acked-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
> ---
>  MAINTAINERS | 160 ++++++++++++++++++++++++++++++++++++++++++++----------------
>  1 file changed, 118 insertions(+), 42 deletions(-)

Cesar, could you fold the firewire hunk into your patch 07/19,
or add this as another patch to that series?  Thanks.
-- 
Stefan Richter
-=====-===-- ==-- -==--
http://arcgraph.de/sr/
