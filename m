Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab0GFRlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 13:41:11 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:42282 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab0GFRlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 13:41:09 -0400
Message-Id: <20100706174028.287568350@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Tue, 06 Jul 2010 19:40:28 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@ftp.linux.org.uk, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] dcache fixes and cleanups
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes sys_getcwd() and symlinks under /proc in case of
unreachable (e.g. lazy unmounted) paths.

The behavior of d_name() is untouched, new helper functions are
introduced instead.

Changes from the previous posting:

 - add helpers to get root and pwd from fs_struct (Nick Piggin's comment)
 - found and fixed a bug in CacheFiles in this area
 - changed ia64/perfmon filesystem to use ->d_dname
 - split up into more managable pataches

Thanks,
Miklos
--
