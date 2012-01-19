Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab2ASNCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:02:35 -0500
Received: from mga06.intel.com ([134.134.136.21]:2745 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075Ab2ASNCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:02:34 -0500
MIME-Version: 1.0
Date: Thu, 19 Jan 2012 15:02:33 +0200
Message-ID: <CALLzPKb6kimUjgj9qN9ehx8RO3-bXvGetFQgx48T1rMm22oD2g@mail.gmail.com>
Subject: dmsetup fails on latest kernel
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

(subject added)

I rebased on the stop of latest mainline tree and now dmsetup fails...
It says: "Failed to create notification semaphore: Function not implemented".
I run strace and saw that dmsetup uses "semget" which returns -ENOSYS...

It works on
122804ecb59493fbb4d31b3ba9ac59faaf45276f

but does not work on
ccb19d263fd1c9e34948e2158c53eacbff369344

Any ideas?

- Dmitry
