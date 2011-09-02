Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337Ab1IBT4F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:56:05 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:39485 "EHLO
	mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755186Ab1IBTz5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:55:57 -0400
From: Serge Hallyn <serge@hallyn.com>
To: akpm@osdl.org, segooon@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, containers@lists.linux-foundation.org,
        dhowells@redhat.com, ebiederm@xmission.com, rdunlap@xenotime.net
Cc: Serge Hallyn <serge@hallyn.com>
Subject: 
Date: Fri,  2 Sep 2011 19:56:24 +0000
Message-Id: <1314993400-6910-2-git-send-email-serge@hallyn.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314993400-6910-1-git-send-email-serge@hallyn.com>
References: <1314993400-6910-1-git-send-email-serge@hallyn.com>
GIT: Lines beginning in "GIT:" will be removed.
GIT: Consider including an overall diffstat or table of contents
GIT: for the patch you are writing.
GIT: Clear the body content if you don't wish to send a summary.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GIT: [PATCH 01/15] add Documentation/namespaces/user_namespace.txt (v3)
GIT: [PATCH 02/15] user ns: setns: move capable checks into per-ns attach
GIT: [PATCH 03/15] keyctl: check capabilities against key's user_ns
GIT: [PATCH 04/15] user_ns: convert fs/attr.c to targeted capabilities
GIT: [PATCH 05/15] userns: clamp down users of cap_raised
GIT: [PATCH 06/15] user namespace: make each net (net_ns) belong to a
GIT: [PATCH 07/15] user namespace: use net->user_ns for some capable
GIT: [PATCH 08/15] af_netlink.c: make netlink_capable userns-aware
GIT: [PATCH 09/15] user ns: convert ipv6 to targeted capabilities
GIT: [PATCH 10/15] net/core/scm.c: target capable() calls to user_ns
GIT: [PATCH 11/15] userns: make some net-sysfs capable calls targeted
GIT: [PATCH 12/15] user_ns: target af_key capability check
GIT: [PATCH 13/15] userns: net: make many network capable calls targeted
GIT: [PATCH 14/15] net: pass user_ns to cap_netlink_recv()
GIT: [PATCH 15/15] make kernel/signal.c user ns safe (v2)
