Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753126Ab0ESOso (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:48:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37347 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752921Ab0ESOsm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:48:42 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] dlm patches for 2.6.35
Date: Wed, 19 May 2010 09:48:31 -0500
Message-Id: <1274280513-14860-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the dlm patches from -next for the 2.6.35 merge.

Dan Carpenter (1):
      dlm: cleanup remove unused code

David Teigland (1):
      dlm: fix ast ordering for user locks

 fs/dlm/lock.c |    5 +--
 fs/dlm/user.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 75 insertions(+), 18 deletions(-)
