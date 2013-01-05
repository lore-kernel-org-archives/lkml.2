Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3AELLR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 06:11:17 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:52701 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab3AELLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 06:11:15 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Sat, 5 Jan 2013 12:11:14 +0100
Message-ID: <CA+icZUVpK2NLUd2tGnvq8y-CWUGk1UDQsso5SQRPPZgp7=ekQA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: mmap: annotate vm_lock_anon_vma locking properly
 for lockdep
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

see my other reply to "[PATCH 1/2] lockdep, rwsem: provide
down_write_nest_lock()" in [1]...

...and feel free to add...

     Tested-by: Sedat Dilek <sedat.dilek@gmail.com>

Thanks!

Regards,
- Sedat -

[1] http://marc.info/?l=linux-mm&m=135738411200967&w=2
