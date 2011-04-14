Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724Ab1DNXSy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 19:18:54 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52204 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754675Ab1DNXSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 19:18:50 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [RFC][PATCH 0/2] Remove __weak definitions of platform PM callbacks
Date: Fri, 15 Apr 2011 01:16:01 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>, Len Brown <lenb@kernel.org>,
        linux-sh@vger.kernel.org, lethal@linux-sh.org,
        Magnus Damm <magnus.damm@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
References: <201104130205.26988.rjw@sisk.pl>
In-Reply-To: <201104130205.26988.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104150116.01634.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches are based on top of
https://patchwork.kernel.org/patch/702401/ .

[1/2] converts shmobile (both the ARM and SH flavors) to using a power domain
for overriding the platform bus type's PM callbacks, which makes it possible
to remove the __weak definitions of the runtime PM callbacks from platform.c,
which is done in [2/2].

Comments welcome.

Thanks,
Rafael

