Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab0JPUsF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 16:48:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54834 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab0JPUsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 16:48:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:subject:date:message-id:x-mailer;
        b=dmGXrPxRHxjY6MjOFv41T3KSGc1vyNtj69uJ3t9VlYA7GRfHiP7Aa+RragPurQnO1y
         cfsqxPLyzTk+GjhNpV3VyPN17FO07Lrg2eRN+tnh7wpX1rXbZRD6YW4bNwHNE1NtRZ/V
         O8vJwZmX96ddG3Hhw2FnEPr1G5ebVCN0MIBds=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@open-nandra.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3 resend] staging:ft1000: Retry sending various not applied patches.
Date: Sat, 16 Oct 2010 22:37:24 +0200
Message-Id: <1287261447-28114-1-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patchset fix yesterday problems with applying some patches
over next tree.
