Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0IZMvW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 08:51:22 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:33683 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab0IZMvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 08:51:21 -0400
Date: Sun, 26 Sep 2010 13:51:17 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Persistant Ext4 error
Message-ID: <20100926125116.GA30683@sucs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've been seeing regular errors when using Ext4 on an EeePC 900 with a
recent 2.6.36 kernel since a few weeks ago.

[  304.096022] EXT4-fs (sdb2): error count: 5
[  304.096034] EXT4-fs (sdb2): initial error at 1284296437: ext4_lookup:1052: inode 141510
[  304.096042] EXT4-fs (sdb2): last error at 1284300370: htree_dirblock_to_tree:586: inode 129800: block 532439

The error seems to persist no matter how much I fsck the partition
(e2fsck comes from e2fsprogs 1.41.11-1ubuntu2). The distro I am using is
Ubuntu 10.04.

Any ideas on what is causing this and how to fix it?

-- 
Sitsofe | http://sucs.org/~sits/
