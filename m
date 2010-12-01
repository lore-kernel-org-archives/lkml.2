Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab0LAS0D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:26:03 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:37953 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133Ab0LAS0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:26:01 -0500
X-IronPort-AV: E=Sophos;i="4.59,284,1288569600"; 
   d="scan'208";a="3140319"
Date: Wed, 1 Dec 2010 18:25:54 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH 0/2] Xen PV on HVM multiple PV consoles
Message-ID: <alpine.DEB.2.00.1012011715070.14723@kaball-desktop>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,
this small patch series achieves two goals:

- make PV consoles work for PV on HVM guests;

- implement support for multiple PV consoles for PV and PV on HVM guests.

Stefano Stabellini (2):
      hvc_xen: support PV on HVM consoles
      hvc_xen: implement multiconsole support

 drivers/char/hvc_xen.c             |  479 ++++++++++++++++++++++++++++++++----
 include/xen/interface/hvm/params.h |    6 +-
 2 files changed, 441 insertions(+), 44 deletions(-)

A branch with these patches on 2.6.37-rc4 is available here:

git://xenbits.xen.org/people/sstabellini/linux-pvhvm.git 2.6.37-rc4-pvhvm-pvconsole

Cheers,

Stefano
