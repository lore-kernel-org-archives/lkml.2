Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833Ab0ESAEp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 20:04:45 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:60925 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab0ESAEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 20:04:43 -0400
Subject: [PATCH 0/3] Make vhost multi-threaded and associate each thread to
 its guest's cgroup/cpumask
From: Sridhar Samudrala <sri@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, netdev <netdev@vger.kernel.org>,
       lkml <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 18 May 2010 17:04:38 -0700
Message-Id: <1274227478.2370.106.camel@w-sridhar.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following set of patches create a new API to associate a
workqueue to the current thread's cgroup and cpumask.
This API is used by multi-threaded vhost to associate each
thread to the corresponding guest's cgroup and cpumask.

Thanks
Sridhar

