Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab2K0U1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:27:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10472 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932176Ab2K0U1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:27:35 -0500
Message-Id: <20121127193501.255267751@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 27 Nov 2012 14:35:01 -0500
From: Aristeu Rozanski <aris@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>,
        cgroups@vger.kernel.org
Subject: [PATCH 0/5] devcg: introduce proper hierarchy support
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements device cgroup hierarchy. Behaviors and exceptions
will be propagated down in the tree and local preferences will be re-evaluated
everytime a change in its parent occours, reapplying them if it's still
possible.

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

-- 
Aristeu
