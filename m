Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757967Ab0LBVCM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 16:02:12 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17611 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab0LBVCL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 16:02:11 -0500
X-PGP-Universal: processed;
	by hqnvupgp02.nvidia.com on Thu, 02 Dec 2010 13:02:10 -0800
From: Andrew Chew <AChew@nvidia.com>
To: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "olofj@chromium.org" <olofj@chromium.org>,
        Stephen Warren <swarren@nvidia.com>
Date: Thu, 2 Dec 2010 13:02:07 -0800
Subject: RE: [PATCH] mfd: tps6586x: Remove device ID check
Thread-Topic: [PATCH] mfd: tps6586x: Remove device ID check
Thread-Index: AcuST2mQM5yayajySr+bxHAodZDs4QAFJcGQ
Message-ID: <643E69AA4436674C8F39DCC2C05F763816BC768D61@HQMAIL03.nvidia.com>
References: <1291314802-18447-1-git-send-email-swarren@nvidia.com>
In-Reply-To: <1291314802-18447-1-git-send-email-swarren@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Stephen Warren [mailto:swarren@nvidia.com] 
> Sent: Thursday, December 02, 2010 10:33 AM
> To: linux-kernel@vger.kernel.org
> Cc: sameo@linux.intel.com; Andrew Chew; olofj@chromium.org; 
> Stephen Warren
> Subject: [PATCH] mfd: tps6586x: Remove device ID check
> 
> ... and convert it to a dev_info print at probe time.
> 
> There are many variants of this chip with different values of 
> VERSIONCRC.
> The set of values is large, and not useful to enumerate. All are SW
> compatible. The difference lies in default settings of the 
> various power
> rails, and other similar differences. The driver, or clients of the
> driver, shouldn't be affected by this, since all rails should be
> programmed into the desired state in all cases for correct operation.
> 
> Derived-from-code-by: Andrew Chew <achew@nvidia.com>
> Signed-off-by: Stephen Warren <swarren@nvidia.com>

LGTM.

Acked by: Andrew Chew <achew@nvidia.com> 
