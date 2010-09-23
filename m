Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab0IWTyd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:54:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756438Ab0IWTyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:54:25 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: vgoyal@redhat.com, hch@lst.de
Subject: [RFT PATCH] amiga, atari floppy: Use one request queue per disk 
Date: Thu, 23 Sep 2010 15:54:04 -0400
Message-Id: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

We seem to have deprecated the notion of sharing request queue across gendisks. Now we need to instanciate one request queue per disk.

There see to be still some drivers sharing request queue across disks. Arch
specific floppy drivers like amiga and atari are doing so.

These are two patches which should fix the issue. But these patches are
completely untested. Not even compilte tested. Don't have hardware to test
them. 

Would be great if somebody who has the hardware can lend a hand here to
see if these patches work.

Thanks
Vivek
