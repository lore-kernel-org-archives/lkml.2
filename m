Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753981Ab2ADLjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 06:39:24 -0500
Received: from smtp.eu.citrix.com ([62.200.22.115]:39471 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2ADLjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 06:39:19 -0500
X-IronPort-AV: E=Sophos;i="4.71,455,1320624000"; 
   d="scan'208";a="9808949"
Subject: [PATCH 0/2] xen: Miscelaneous xenbus cleanups
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
        Haogang Chen <haogangchen@gmail.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>
Date: Wed, 4 Jan 2012 11:39:17 +0000
In-Reply-To: <1325669689.25206.181.camel@zakaz.uk.xensource.com>
References: <1325619731-13936-1-git-send-email-haogangchen@gmail.com>
	 <1325669095.25206.176.camel@zakaz.uk.xensource.com>
	 <1325669689.25206.181.camel@zakaz.uk.xensource.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3- 
Content-Transfer-Encoding: 7bit
Message-ID: <1325677158.25206.244.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a couple of things I noticed while reviewing Haogang's patch.
Applies on top of my suggested replacement for that patch (in
<1325669689.25206.181.camel@zakaz.uk.xensource.com>).

Not extensively tested but I did run it in dom0 and start both and HVM
and PV guest.

Ian.

