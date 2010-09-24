Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331Ab0IXQuC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:50:02 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46574 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932794Ab0IXQt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:49:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=tEFU+jfoT0e981pnfxdlMx5CN4fu6UXJ4dMM3hf1+7Z2nRXln0aSX3BQHG6IhJSDUL
         fS2h+J51WWmqxA66R6S6LNZ820mJIoCbxblxSbuW7tMJPOCq8G3Z6d1VZkETZ1oIwuZn
         ZMTwQ+/JgUyOlZCj292ZlLalQ3TGcGJyMssLc=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>, linux-pcmcia@lists.infradead.org
Subject: [PATCH 0/5] Add programs to work with CIS files
Date: Fri, 24 Sep 2010 20:49:20 +0400
Message-Id: <1285346965-23499-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

linux-firmware.git has several CIS files - special files fixing bugs in
description of PCMCIA hardware. Those files are binary, but they can be (and
most probably were in the past) generated from simple text files by the use
of special compiler (developed by pcmcia-cs project). This patch serie
adds text sources of CIS files and two programs to convert between text and
binary representations of CIS files.

