Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab0CaPZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 11:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756389Ab0CaPZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 11:25:05 -0400
Subject: RFC [Patch] Remove "please try 'cgroup_disable=memory' option if
	you don't want memory cgroups" printk at boot time.
From: Larry Woodman <lwoodman@redhat.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 31 Mar 2010 11:28:03 -0400
Message-Id: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are considering removing this printk at boot time from RHEL because
it will confuse customers, encourage them to change the boot parameters
and generate extraneous support calls.  Its documented in
Documentation/kernel-parameters.txt anyway.  Any thoughts???

Larry Woodman


