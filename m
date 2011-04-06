Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab1DFOpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 10:45:19 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45135 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756260Ab1DFOpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 10:45:17 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, kernel@pengutronix.de
Subject: [PATCH] drivers/char/applicom.c: remove cvs ID and French in-file changelog
Date: Wed,  6 Apr 2011 16:45:11 +0200
Message-Id: <1302101111-23992-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20101206151929.GA21020@pengutronix.de>
References: <20101206151929.GA21020@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My script that finds typos always wants to do s/acces/access/ and
claims that "addresse" is wrong.  While at it remove obsolete cvs id and
outdated reference to kernel version.

Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/char/applicom.c |   19 +------------------
 1 files changed, 1 insertions(+), 18 deletions(-)

diff --git a/drivers/char/applicom.c b/drivers/char/applicom.c
index 25373df..3e7af43 100644
--- a/drivers/char/applicom.c
+++ b/drivers/char/applicom.c
@@ -1,24 +1,7 @@
 /* Derived from Applicom driver ac.c for SCO Unix                            */
 /* Ported by David Woodhouse, Axiom (Cambridge) Ltd.                         */
 /* dwmw2@infradead.org 30/8/98                                               */
-/* $Id: ac.c,v 1.30 2000/03/22 16:03:57 dwmw2 Exp $			     */
-/* This module is for Linux 2.1 and 2.2 series kernels.                      */
-/*****************************************************************************/
-/* J PAGET 18/02/94 passage V2.4.2 ioctl avec code 2 reset to les interrupt  */
-/* ceci pour reseter correctement apres une sortie sauvage                   */
-/* J PAGET 02/05/94 passage V2.4.3 dans le traitement de d'interruption,     */
-/* LoopCount n'etait pas initialise a 0.                                     */
-/* F LAFORSE 04/07/95 version V2.6.0 lecture bidon apres acces a une carte   */
-/*           pour liberer le bus                                             */
-/* J.PAGET 19/11/95 version V2.6.1 Nombre, addresse,irq n'est plus configure */
-/* et passe en argument a acinit, mais est scrute sur le bus pour s'adapter  */
-/* au nombre de cartes presentes sur le bus. IOCL code 6 affichait V2.4.3    */
-/* F.LAFORSE 28/11/95 creation de fichiers acXX.o avec les differentes       */
-/* addresses de base des cartes, IOCTL 6 plus complet                         */
-/* J.PAGET le 19/08/96 copie de la version V2.6 en V2.8.0 sans modification  */
-/* de code autre que le texte V2.6.1 en V2.8.0                               */
-/*****************************************************************************/
-
+/* several changes by J. Paget and F. Laforse in 1994-1996 */
 
 #include <linux/kernel.h>
 #include <linux/module.h>
-- 
1.7.2.3

