Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2LRTbJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 14:31:09 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:39266 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751096Ab2LRTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 14:31:07 -0500
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 14:31:07 EST
MIME-Version: 1.0
Date: Tue, 18 Dec 2012 13:25:38 -0600
Message-ID: <CAH2r5mtDOhCiAi9yJMYDyj8C_eKDLVVH8e1ZHPMdGaH3PGBtJQ@mail.gmail.com>
Subject: setting crypto signing key
From: Steve French <smfrench@gmail.com>
To: linux-cifs@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cifs calls crypto_shash_setkey repeatedly (every time we do
smb2_calc_signature in fs/cifs/transport.c).  Shouldn't this only be
called only once (at sesion establishment time, or whenever the
session key changes due to network reconnection) not on every request?

-- 
Thanks,

Steve
