Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759535Ab2HIUAE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 16:00:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40328 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755071Ab2HIUAB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 16:00:01 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>, Ben Hutchings <ben@decadent.org.uk>
Subject: Bug fixes/cleanups for floppy driver (v2)
Date: Thu,  9 Aug 2012 16:59:45 -0300
Message-Id: <1344542391-16474-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following this are fixes for bugs I noticed on floppy driver, and some
extra cleanups.

v2: separate fixes, and incorporate suggestions by Vivek Goyal.
    also I splitted the cleanups from fixes.

-- 
[]'s
Herton
