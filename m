Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446Ab2HQBqJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 21:46:09 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:40739 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab2HQBqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 21:46:04 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: [PATCH -next 0/3] firmware loader: fix build failure 
Date: Fri, 17 Aug 2012 09:45:46 +0800
Message-Id: <1345167949-7419-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These 3 patches fix build failure reported by Fengguang aginst
driver-core -next tree.

The 2nd patch introduces dpm_for_each_dev in drivers/base/power
to fix link failure if firmware loader is complied as moudle.

Rafael, could you comment on the 2nd patch?

Thanks,
--
Ming Lei

