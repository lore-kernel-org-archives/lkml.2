Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754032Ab1IWNGR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 09:06:17 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40201 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab1IWNGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 09:06:16 -0400
MIME-Version: 1.0
Date: Fri, 23 Sep 2011 17:06:15 +0400
Message-ID: <CAJBOZRqQJjPeEa_HBXvpOWRNcRaLvL2zQy=LtDpmBChxh7B24g@mail.gmail.com>
Subject: READ/RENEW loop bug again?
From: Vladimir Kozlov <vladimir.kozlov@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I've found this thread -
http://linux-nfs.org/pipermail/nfsv4/2010-January/012042.html - trying
to understand why I've got a huge traffic on NFS server followed by
killing almost everything by oom-killer.
It seems that I face the same bug, but using newest kernels in Ubuntu
10.04 LTS - I had 2.6.32-33-generic-pae, then I tried with
2.6.38-10-generic-pae (backported from 11.04) but with the same
problem.

Could you please advice are there any workarounds? I will be hapy to
give as much information as I can.

Kind regards,

Vladimir.
