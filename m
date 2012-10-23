Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965609Ab2JWVI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 17:08:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:46731 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965573Ab2JWVHT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 17:07:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,637,1344236400"; 
   d="scan'208";a="208148419"
From: "Luck, Tony" <tony.luck@intel.com>
To: Kees Cook <keescook@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "Yu, Fenghua" <fenghua.yu@intel.com>
Subject: RE: [PATCH 011/193] arch/ia64: remove CONFIG_EXPERIMENTAL
Thread-Topic: [PATCH 011/193] arch/ia64: remove CONFIG_EXPERIMENTAL
Thread-Index: AQHNsVmsCfa+wDfOIEm0PgC37rWNvJfHYZsQ
Date: Tue, 23 Oct 2012 21:07:17 +0000
Message-ID: <3908561D78D1C84285E8C5FCA982C28F19D58EE4@ORSMSX108.amr.corp.intel.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-12-git-send-email-keescook@chromium.org>
In-Reply-To: <1351022666-6960-12-git-send-email-keescook@chromium.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.

Acked-by: Tony Luck <tony.luck@intel.com>

[ditto for parts 012 and 013 of 193]

