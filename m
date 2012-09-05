Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab2IEEis (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 00:38:48 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53227 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903Ab2IEEir convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 00:38:47 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/5] regulator: lp872x: remove platform data dependency
Thread-Topic: [PATCH 0/5] regulator: lp872x: remove platform data dependency
Thread-Index: Ac2LIFHxjik4Dnf9R7ajVwJ9jiZ9Iw==
Date: Wed, 5 Sep 2012 04:38:40 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF21B9@DQHE02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch-set removes the platform data dependency.
The LP872x driver should be run even if the platform data is not defined.

5 patches enable running the driver in case the LP8720/8725
platform data has no configuration.

[PATCH 1/5] regulator: lp872x: remove regulator platform data dependency
[PATCH 2/5] regulator: lp872x: set the default DVS mode
[PATCH 3/5] regulator: lp872x: initialize the DVS mode
[PATCH 4/5] regulator: lp872x: fix NULL pointer access problem
[PATCH 5/5] regulator: lp872x: remove unnecessary function

Thank you.

Best Regards,
Milo


