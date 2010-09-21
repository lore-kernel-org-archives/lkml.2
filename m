Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab0IUHVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 03:21:34 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60076 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755589Ab0IUHVc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 03:21:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BWUX+4OC8TLwznHa/hNoroU8wBrtpbCH2biGaBwENHAl+Is01TOfPRDNFF/SdL21Lm
         7f2KNvVboH4Ih2IAlJTSo7MGbzUiN6wRSj3xwIKABahedgRzWZ+Mtz4PXEpEWdKCj3KX
         R3cDYQfDuo+cW3YhjXXLfcI9wXrDEZGRaOtUc=
Subject: RE: [PATCH] usibfs: fix kconfig dependency warning
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Jon Povey <Jon.Povey@racelogic.co.uk>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@nokia.com>
In-Reply-To: <70E876B0EA86DD4BAF101844BC814DFE093ED5F718@Cloud.RL.local>
References: <70E876B0EA86DD4BAF101844BC814DFE093ED5F718@Cloud.RL.local>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 21 Sep 2010 10:19:41 +0300
Message-ID: <1285053581.7512.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 05:23 +0100, Jon Povey wrote:
> linux-mtd-bounces@lists.infradead.org wrote:
> > Pushed to the ubifs-2.6.git tree.
> 
> If the typo "usibfs" in the subject was in the patch you might want to
> fix it if there's still time.

I fixed it up. I never apply patches without looking at the subject
line, and I always use git am -i, which means edit the commit message
before applying.

So it is ok, thanks for heads up though!

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

