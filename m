Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2ASNAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 08:00:21 -0500
Received: from mga12.intel.com ([143.182.124.36]:21679 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751075Ab2ASNAT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 08:00:19 -0500
MIME-Version: 1.0
Date: Thu, 19 Jan 2012 15:00:17 +0200
Message-ID: <CALLzPKYdD22kg9QCtzLsENwTmBnkZqJ6sykrU1PoadTLMXtHTg@mail.gmail.com>
Subject: 
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: device-mapper development <dm-devel@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I rebased on the stop of latest mainline tree and now dmsetup fails...
It says: "Failed to create notification semaphore: Function not implemented".
I run strace and saw that dmsetup uses "semget" which returns -ENOSYS...

Any ideas?

- Dmitry
