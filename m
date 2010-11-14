Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab0KNCHQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 21:07:16 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:46015 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab0KNCHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 21:07:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=FCD0FQbYjYJqCUWpSPRfLTRDxVbL6m/bIZNzo/a3I8bu5Hv/PMk41p1MkPvo80SoZW
         pBgP/vP+ziVC6sPZCduyg2nPR/cCUY+uZvBv8DLClx6VDNYsPMTtoPD/8YdRzn5kIY/W
         2B0NkgcF90oFxmFihnSiMwh587kIjSaV1uesc=
From: Hai Shan <haishan.bai@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Corrected data type mismatch in kgdb Powerpc
Date: Sun, 14 Nov 2010 10:06:58 +0800
Message-Id: <1289700419-11072-1-git-send-email-shan.hai@windriver.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Corrected data type mismatch in kgdb Powerpc
