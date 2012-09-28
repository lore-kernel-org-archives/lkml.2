Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758876Ab2I1XdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 19:33:09 -0400
Received: from nm6.bullet.mail.sp2.yahoo.com ([98.139.91.76]:49075 "HELO
	nm6.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758768Ab2I1XdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 19:33:06 -0400
X-Yahoo-Newman-Id: 381855.29877.bm@omp1012.access.mail.sp2.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4i..U3AVM1m1CGSJWLnUNkYRBeAkk9P7dM.W5Ch98EAuk4E
 ovmZkqQ7apE9fG_VCPAqEk.OwUftvWUrnQ26pdSzS_vVDdRjrLzEwcgnt2qN
 dKsUFMOpQc3aD6irNrsDciV4WYXfqYxeT7viB2.Ch08Uj7qsdVNvQuF2ya.T
 7BxoN4w3iMTtpxkxW_ywU5qctbn74zl016OmEWilFGJ48uhnBFERv_YpPWwZ
 3G94DefedFKtJaQaaNyd91fD5wkqr9LpQwJETY.9KHJ3Ev0bsrtNOSVebbbM
 r1sp0OdFLZ3YFYpmJZ9pSypRCWtEFJPQbS5mqEoNSM6bFIWI_wFKWf82V0Sz
 t1AJDQlT1qNjZ8BKysEiOhzNsSqiXx_C_bz.kVHVIc8lhrILMG.nIUM9ZcfV
 KeCc2Lf3lemApAxLH9F_NDZrCUxnMUnHaoFXkw1nuTmVHpisfavY-
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
From: Daniel Santos <daniel.santos@pobox.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH 0/3] kernel-doc bug fixes
Date: Fri, 28 Sep 2012 18:32:55 -0500
Message-Id: <1348875178-28490-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fixes breakages exposed by doc-comments used in the generic red-black
tree patch set.
