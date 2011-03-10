Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab1CJGcu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 01:32:50 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:58450 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1CJGci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 01:32:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=mlSHaNWx0+CtWebqU1soX1aPr4nbFuobiKzt7SBPNts1MSvIHo01G4PnqluX+tWt4P
         3rvqdWCFSiq+DJtyIv4TaISBjgARyrkePP3QTfJlLC7zHLiMjOjBLlpVCv0YhwWTU9LR
         A+8EgSXelC9clezSIhPghnM/OfQ/vQvW2uLZU=
Date: Thu, 10 Mar 2011 14:32:16 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: akpm@linux-foundation.org, joe@perches.com, davem@davemloft.net,
        greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH]add a note for MAINTAINERS
Message-ID: <20110310063214.GA9990@gmail.com>
Mail-Followup-To: akpm@linux-foundation.org, joe@perches.com,
	davem@davemloft.net, greg@kroah.com, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
   Steven said we should add a note for MAINTAINERS,
which we should remove all individual 
linux-kernel@vger.kernel.org in maintainers' "L:"
except linus's.
   Joe perches removed them and Andrew Morton
already picked up his.
   So i patch for Steven's thoughts.

Thanks.
Best Regards.
Harry Wei.

Signed-off-by: Harry Wei <harryxiyou@gmail.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 560ecce..7117905 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -42,6 +42,12 @@ trivial patch so apply some common sense.
 	your changes in a branch derived from Linus' latest git tree.
 	See Documentation/SubmittingPatches for details.
 
+	PLEASE CC: the main mailing list linux-kernel@vger.kernel.org
+	which is relevant to any patch about kernel. So you should always
+	send your patch to this mailing list. If you are a maintainer
+	who want to add yourself to this file, you should not add it
+	to your "L:".
+
 	PLEASE try to include any credit lines you want added with the
 	patch. It avoids people being missed off by mistake and makes
 	it easier to know who wants adding and who doesn't.
-- 
1.7.0.4


