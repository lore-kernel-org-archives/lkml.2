Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318Ab0KTJ7s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 04:59:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62506 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761Ab0KTJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 04:59:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=DjgwkHuXUBQsC/fa+GyBZRYn89jnlY1Q0i4kA0Qegx3Yo33GcUHGyYIX+QlC1I6/7x
         cmn8fUtf6fn4VQo/vWgF9467hE4vSVV9/tqj5weLh+MeSn1WuZ9gRU0kiqgBXAe8aEAx
         OGfilBc1SU6aKe5ib5n4S7pbhDAnrufuRLTGc=
Message-ID: <4CE79B4C.7030001@gmail.com>
Date: Sat, 20 Nov 2010 10:56:28 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 00/16 v4] pramfs: persistent and protected RAM filesystem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

fourth round for the patch series. I summarize here the changes to
improve the review:

v4:
- in bitmap init used already present bitmap_set function
- fix a possible memory leak in an error path reported by yidong zhang

v3:
- fix a possible memory leak in an error path reported by yidong zhang
- fix a warning when using XIP about not used __pram_mmap symbol
- fix test module header description and replaced TEST_MODULE with
PRAMFS_TEST_MODULE in the Kconfig and Makefile according to the comments
done by Randy Dunlap
- fix a compilation warning in super.c reported by James Hogan
- fix a compilation error when XIP was enabled
- removed not used symbol PRAM_XATTR_INDEX_LUSTRE
- fix some comment style issue

v2:
- fix documentation errors reported by Randy Dunlap and Kieran Bingham
- reworked memory write protection functions with the suggestions of
Andi Kleen

v1:
- first draft

Andrew/Greg, can you insert the code in the mm/staging tree?

Marco
