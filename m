Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab1EWP50 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 11:57:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50359 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab1EWP5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 11:57:24 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] dlm patches for 2.6.40
Date: Mon, 23 May 2011 10:57:16 -0500
Message-Id: <1306166240-3359-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
These are the dlm patches for the 2.6.40 merge.

 fs/dlm/config.c           |    9 ++-
 fs/dlm/config.h           |    1 +
 fs/dlm/dlm_internal.h     |    3 +
 fs/dlm/lock.c             |  182 +++++++++++++++++++++++++++++++++++----------
 fs/dlm/lock.h             |    1 +
 fs/dlm/lockspace.c        |    6 +-
 fs/dlm/plock.c            |   65 +++++++++++++++-
 fs/dlm/user.c             |    1 -
 include/linux/dlm_plock.h |    6 +-
 9 files changed, 223 insertions(+), 51 deletions(-)

David Teigland (3):
      dlm: delayed reply message warning
      dlm: remove shared message stub for recovery
      dlm: make plock operation killable

Matt Fleming (1):
      dlm: Remove superfluous call to recalc_sigpending()


