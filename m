Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab0I1OZ2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 10:25:28 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:32896 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755470Ab0I1OZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 10:25:26 -0400
Message-Id: <20100928142058.796669370@linux.vnet.ibm.com>
User-Agent: quilt/0.48-1
Date: Tue, 28 Sep 2010 16:20:58 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        Shailabh Nagar <nagar1234@in.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] taskstats: Cleanup patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,

It would be great, if you could accept the taskstats cleanup patches that
are the prerequisite for the taskstats precise accounting patches. The
patches do not add any new functionality. I think they make the code better
readable and extensible:
* 01/02: taskstats: Separate taskstats commands
* 02/02: taskstats: Split fill_pid function

Michael
