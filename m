Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab0HCOxO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 10:53:14 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52593 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932090Ab0HCOxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 10:53:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=dN8lpRLO92AHC38+Z824u1MuzNWI3V+pTvP2gP50V0tck0Hfn987s5VN+Kgcf0Ni8/
         63TI8UfQIn6QNNVwPLdju7m26mM15SHZq5j92td5k/abqIWzw14BjiaZJxOk63TiPn11
         q4WYZtpkF4nPQ5Kr5ZEzc0z85dMOJOkqXkAcw=
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Alex Dubov <oakad@yahoo.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] Driver for Ricoh cardreader
Date: Tue,  3 Aug 2010 17:53:04 +0300
Message-Id: <1280847186-11501-1-git-send-email-maximlevitsky@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is the driver for the reader I have.
Plus one fix for hangs on unclean removal introduced my changes in block core.

This is just writen and debbuged, but works very well now.
I don't know if possible, but I would like to see that in 2.6.36, because
this is new driver, so no posiibility of regressions.

Best regards,
	Maxim Levitsky


