Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261Ab1FNQrk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 12:47:40 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:45204 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab1FNQrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 12:47:39 -0400
Date: Tue, 14 Jun 2011 20:46:49 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Dan Carpenter <error27@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        Tomas Winkler <tomas.winkler@intel.com>,
        Mike Thomas <rmthomas@sciolus.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging/easycap: Fix thinko in "bars" module
	option description
Message-ID: <20110614164649.GB29015@tugrik.mns.mnsspb.ru>
References: <cover.1307967011.git.kirr@mns.spb.ru> <14c0e4d0bb7ef1a05b9dcc14b2b51c706f844655.1307967011.git.kirr@mns.spb.ru> <20110613122717.GF3583@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110613122717.GF3583@shale.localdomain>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 03:27:17PM +0300, Dan Carpenter wrote:
> On Mon, Jun 13, 2011 at 04:18:29PM +0400, Kirill Smelkov wrote:
> > Both bars=0 and bars=1 were described as meaning to display bars on
> > signal lost. Actually bars=1 means "display bars", but bars=0 means
> > display raw source as is (usually black screen).
> 
> Your description up here is much better than the one in the README.
> Maybe just include yours and delete the original.

Thanks for head ups. Something like this:

---- 8< ----
From: Kirill Smelkov <kirr@mns.spb.ru>
Date: Mon, 13 Jun 2011 15:09:31 +0400
Subject: [PATCH v2] staging/easycap: Fix thinko in "bars" module option
 description

Both bars=0 and bars=1 were described as meaning to display bars on
signal lost. Actually bars=1 means "display bars", but bars=0 means
display raw source as is (usually black screen).

Instead of changing bars=0 to "_no_ testcard bars ..." as suggested by
Dan Carpenter reword the whole bars description for clarity.

Cc: Tomas Winkler <tomas.winkler@intel.com>
Cc: Mike Thomas <rmthomas@sciolus.org>
Cc: Dan Carpenter <error27@gmail.com>
Signed-off-by: Kirill Smelkov <kirr@mns.spb.ru>
---
 drivers/staging/easycap/README |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/easycap/README b/drivers/staging/easycap/README
index 16b8264..dadceb9 100644
--- a/drivers/staging/easycap/README
+++ b/drivers/staging/easycap/README
@@ -60,8 +60,8 @@ Three module parameters are defined:
 
 debug      the easycap module is configured at diagnostic level n (0 to 9)
 gain       audio gain level n (0 to 31, default is 16)
-bars       0 =>  testcard bars when incoming video signal is lost
-           1 =>  testcard bars when incoming video signal is lost (default)
+bars       whether to display testcard bars when incoming video signal is lost
+           0 => no, 1 => yes (default)
 
 
 SUPPORTED TV STANDARDS AND RESOLUTIONS
-- 
1.7.6.rc1

