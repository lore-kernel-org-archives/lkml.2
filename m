Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1JKR1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 13:27:54 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:49655 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab1JKR1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 13:27:53 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
        "linux-btrfs" <linux-btrfs@vger.kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Two small btrfs fixes
Date: Tue, 11 Oct 2011 13:27:43 -0400
Message-Id: <1318353941-sup-6080@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E947C98.00A4:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Li Zefan hit some problems with looping in the btrfs autodefrag mode.

These two commits are in the btrfs-3.0 branch:

git://github.com/chrismason/linux.git btrfs-3.0


Chris Mason (1) commits (+3/-1):
    Btrfs: make sure not to defrag extents past i_size

Li Zefan (1) commits (+7/-0):
    Btrfs: fix recursive auto-defrag

Total: (2) commits (+10/-1)

 fs/btrfs/ioctl.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)
