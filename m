Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756362Ab0KMOuz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 09:50:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60245 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab0KMOuw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 09:50:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=Wi94BpqxBDLui7OFNht4QxetXCfvDgKxuhpUNZz/eW3zJ/zMCmV1rDc/HTlcDYAMy6
         eG37bEUYrr3YIUiFMkaG9PDhDvJDPypnl8c9alHjxUK0/vxNgN5IwWHC1u6tsVGN6VXt
         6zaKLmfBot4g5Ml064nuIizI1hYmFWKxSG2AM=
Message-ID: <4CDEA500.4050401@gmail.com>
Date: Sat, 13 Nov 2010 15:47:28 +0100
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: Linux Embedded <linux-embedded@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Tim Bird <tim.bird@am.sony.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 00/16 v3] pramfs: persistent and protected RAM filesystem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

third round for the patch series (I hope this is the last one :)). I
summarize here the changes to improve the review:

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

Marco
