Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754633Ab1EQM4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 08:56:04 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:36722 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754327Ab1EQM4D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 08:56:03 -0400
From: Borislav Petkov <bp@amd64.org>
To: Nick Bowler <nbowler@elliptictech.com>,
        =?UTF-8?q?J=C3=B6rg-Volker=20Peetz?= <jvpeetz@web.de>
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: =?UTF-8?q?=5BPATCH=200/2=5D=20AMD=20ARAT=20fixes?=
Date: Tue, 17 May 2011 14:55:17 +0200
Message-Id: <1305636919-31165-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi all,

the following 2 patches address the fallout caused by
b87cf80af3ba4b4c008b4face3c68d604e1715c6. They enable ARAT only on
Fam10h and later, and leaves out K8 due to multiple problems there.

Although the patches look almost trivial, I'd like to ask Nick and
Jörg-Volker to test them, please, so that we can have a confirmation,
just in case.

Then, if we're lucky and Linus hasn't released .39 yet, we might sneak
them in, if we ask people politely :).

Thanks.
