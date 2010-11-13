Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab0KMWnT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 17:43:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59062 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab0KMWnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 17:43:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=YmbCar4ekLPK3IZIZ5gylRkT/iJg0/YfMJz/cJGxdk6DGMOnSG7Kp/Mi1VUsF+TOtU
         WoHICPrMrOqiMVmmJZCn7h2IvtFGy33APhfycFoMthlO4RbL+gE2dD8E9aucvCncIvpZ
         RfoFa0SHo2wdlqUjIJzJ5+9NUXLT2C60cS7WA=
MIME-Version: 1.0
Date: Sat, 13 Nov 2010 15:43:15 -0700
Message-ID: <AANLkTikft6k1oh730OXoKu6sDuJEROMTTohhWJAkoq5T@mail.gmail.com>
Subject: [ANNOUNCE] MDB Merkey's Linux Kernel Debugger 2.6.36 x86_64 11-13-2010
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CURRENT
http://merkeydebugger.googlecode.com/files/mdb-2.6.36-x86_64-10-31-2010.patch

REPOSITORY
http://code.google.com/p/merkeydebugger/
http://sourceforge.net/projects/merkeydebugger/


FIXES:
- port to 2.6.36 and test
- fix patch delta changes and Fuzz warnings.
- fix keyboard problems with spurious interrupts with heaving loading

Jeff Merkey
