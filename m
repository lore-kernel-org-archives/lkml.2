Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab0JHT2L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 15:28:11 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48248 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759367Ab0JHT2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 15:28:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=WnuMU84bB+4u64+UrbZUSNOvfcm455gGeIjBOsIqGtsKYZk9UdPlFFG4kfxfftDCt1
         SpT+w0k7mxxtI0dFnNkwPhlJ42qm1Z0pSXLnUpVNTGzoVF2m1J3DEkZR2146cXIrtPJr
         NrLjSFfb+2aeGFustZn6RWk5F1I13ZZb6WRQA=
From: Nicolas Palix <npalix.work@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>, Nicolas Palix <npalix.work@gmail.com>,
        Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: [PATCH 0/6] Update coccinelle related files/information
Date: Fri,  8 Oct 2010 21:27:35 +0200
Message-Id: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Palix (6):
  MAINTAINERS: Coccinelle: Update email address
  Coccinelle: Update documentation
  Coccinelle: Improve user information with a new kind of comment
  Coccinelle: Use new comment format to explain kfree.cocci
  Coccinelle: Add a new mode named 'chain'
  Coccinelle: Use the -no_show_diff option for org and report mode

 Documentation/coccinelle.txt        |   42 +++++++++++++++++++++++++++++-----
 MAINTAINERS                         |    2 +-
 scripts/coccicheck                  |   30 +++++++++++++++++++-----
 scripts/coccinelle/free/kfree.cocci |    9 ++++---
 4 files changed, 64 insertions(+), 19 deletions(-)

