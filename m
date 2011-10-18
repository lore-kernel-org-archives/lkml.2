Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244Ab1JRCa4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 22:30:56 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:55282 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757168Ab1JRCay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 22:30:54 -0400
From: pingfank@linux.vnet.ibm.com
To: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Cc: Liu Ping Fan <pingfank@linux.vnet.ibm.com>
Subject: Currnetly, how can host know the cpu unplug event on guest
Date: Tue, 18 Oct 2011 10:30:03 +0800
Message-Id: <1318905003-9914-1-git-send-email-pingfank@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Liu Ping Fan <pingfank@linux.vnet.ibm.com>

Could anyone tell me currently, for kvm, what method to let the host know the guest's cpu unplug event?

Thanks,
ping fan
