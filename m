Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab1JLVXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:23:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754220Ab1JLVXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:23:04 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: tj@kernel.org, christophe@saout.de, dm-devel@redhat.com,
        msnitzer@redhat.com
Subject: [PATCH 0/2] block: fix flush regression introduced in 3.1-rc3
Date: Wed, 12 Oct 2011 17:22:40 -0400
Message-Id: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch series fixes a regression introduced by commit
4853abaae7e4a2af938115ce9071ef8684fb7af4.  I've tested that this solves
the problem when dm-mpath is backed by devices that require a write
cache flush.  I've also ensured that this does not reintroduce the
performance problems that the original fix solved.

Cheers,
Jeff

