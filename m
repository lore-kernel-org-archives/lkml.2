Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762601Ab0GUFVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 01:21:49 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:36648 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab0GUEwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 00:52:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Nhs8U6jFgM2/lkJKqgt88Fv//3oonhoqT+fjdcO+KLsToskdaa/ES0yUDN1MPfdEWt
         GftsOsSoA6UFeSgELQTIfwEn9+NaZzNHie8zNmS64cw7YDuPksb81O4Gt/qE+dh9PBJp
         N7TM3Tzlc0pAeal4FhT2kZNdXKUwBlPmRpsns=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 24/24]Documentation/DocBook/v4l/compat.xml update web address.
Date: Tue, 20 Jul 2010 21:52:00 -0700
Message-Id: <1279687926-29360-9-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
In-Reply-To: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
References: <1279687926-29360-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes a web address, due to me
being unable to locate this at all. If anybody knows
where this one is let me know, and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/DocBook/v4l/compat.xml |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/DocBook/v4l/compat.xml b/Documentation/DocBook/v4l/compat.xml
index b42b935..b03b663 100644
--- a/Documentation/DocBook/v4l/compat.xml
+++ b/Documentation/DocBook/v4l/compat.xml
@@ -1090,9 +1090,8 @@ stream. The data type name for timestamps is stamp_t, defined as a
 signed 64-bit integer. Output devices should not send a buffer out
 until the time in the timestamp field has arrived. I would like to
 follow SGI's lead, and adopt a multimedia timestamping system like
-their UST (Unadjusted System Time). See
-http://reality.sgi.com/cpirazzi_engr/lg/time/intro.html. [This link is
-no longer valid.] UST uses timestamps that are 64-bit signed integers
+their UST (Unadjusted System Time).
+UST uses timestamps that are 64-bit signed integers
 (not struct timeval's) and given in nanosecond units. The UST clock
 starts at zero when the system is booted and runs continuously and
 uniformly. It takes a little over 292 years for UST to overflow. There
-- 
1.7.1.rc1.21.gf3bd6

