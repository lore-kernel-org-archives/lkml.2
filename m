Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754239Ab1BALVv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 06:21:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab1BALVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 06:21:50 -0500
From: Gleb Natapov <gleb@redhat.com>
To: avi@redhat.com, mtosatti@redhat.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] KVM: enable asynchronous page faults
Date: Tue,  1 Feb 2011 13:21:45 +0200
Message-Id: <1296559307-14637-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series is on top of Huang Ying "Replace is_hwpoison_address with
__get_user_pages" series: http://www.mail-archive.com/kvm@vger.kernel.org/msg48776.html

Gleb Natapov (2):
  Allow GUP to fail instead of waiting on a page.
  KVM: Enable async page fault processing.

 include/linux/mm.h  |    2 ++
 mm/filemap.c        |    6 ++++--
 mm/memory.c         |    5 ++++-
 virt/kvm/kvm_main.c |   23 +++++++++++++++++++++--
 4 files changed, 31 insertions(+), 5 deletions(-)

