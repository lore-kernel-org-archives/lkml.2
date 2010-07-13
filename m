Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756045Ab0GMCZp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 22:25:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab0GMCZo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 22:25:44 -0400
From: Zachary Amsden <zamsden@redhat.com>
To: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>
Cc: Linux-kernel <linux-kernel@vger.kernel.org>
Subject: KVM timekeeping fixes, V2
Date: Mon, 12 Jul 2010 16:25:20 -1000
Message-Id: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Discovered brammage in patches due to unresolved merge.
Also, had to move 09/18 past 08/18 to resolve compile issue.

