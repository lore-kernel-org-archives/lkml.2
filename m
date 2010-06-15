Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab0FOMae (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 08:30:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34724 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153Ab0FOMad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 08:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=i/7xDSCXaMpdDAQ2O8AUa2vvs5Jni8Y3FCC6vAyObCpkQiMQenGkQ39ePC093o3tPg
         mtGpvX7pVgaQXAlVZgYce4i2AE0loQXoUyTt9JWWefrda/6y5or7R2SgPjc3YJoWBOpR
         9X7RioZ2wD7vb7UXrOOIPCwXbkYnS58peAS/U=
MIME-Version: 1.0
Date: Tue, 15 Jun 2010 15:30:30 +0300
Message-ID: <AANLkTilYqkiOhcaq7iuDJ8pP5wDCj-rmj1VLuRCsuQ6v@mail.gmail.com>
Subject: Block I/O layer semantics
From: Thanos Makatos <tmakatos@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I want to learn whether there are exact semantics offered by the Linux
block I/O layer. Specifically, I would like to know the following:
1. Can a write request bypass a read request (both in flight) that
access the same sector number? Does the I/O scheduler has anything to
do with it? I suppose it is legal since both these requests are
concurrent, however I can't find it anywhere clearly documented. And,
as a consequence:
2. A read request must return the contents of the last completed
write, right? (Obviously this shouldn't happen, still need a
confirmation, through..)

Thank you.

P.S: Please CC me on your reply - I haven't subscribed to the list.

-- 
Thanos Makatos
