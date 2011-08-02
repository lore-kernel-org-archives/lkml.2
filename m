Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab1HBJpk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 05:45:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750807Ab1HBJpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 05:45:36 -0400
From: Igor Mammedov <imammedo@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] xen: small fixes and cleanups at arch/x86/xen/setup.c
Date: Tue,  2 Aug 2011 11:45:22 +0200
Message-Id: <1312278325-4246-1-git-send-email-imammedo@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Some fixes/cleanups as result of backporting xen ballooning to rhel6.
 Thanks to Laszlo Ersek for spotting bugs.

