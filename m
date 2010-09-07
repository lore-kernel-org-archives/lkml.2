Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab0IGXH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:07:29 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15466 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0IGXH1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:07:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp03.nvidia.com on Tue, 07 Sep 2010 16:07:25 -0700
From: Andrew Chew <AChew@nvidia.com>
To: "'Datta, Shubhrajyoti'" <shubhrajyoti@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Tue, 7 Sep 2010 16:07:23 -0700
Subject: RE: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Thread-Topic: [PATCH 1/1] iio: ak8975: Add Ak8975 magnetometer sensor
Thread-Index: ActK/I9N9is6KwSRSO+mVM+JyVFhbAClNv1AAFP8PaA=
Message-ID: <643E69AA4436674C8F39DCC2C05F763816B85AD0A9@HQMAIL03.nvidia.com>
References: <1283470837-18210-1-git-send-email-achew@nvidia.com>
 <0680EC522D0CC943BC586913CF3768C003C2018464@dbde02.ent.ti.com>
In-Reply-To: <0680EC522D0CC943BC586913CF3768C003C2018464@dbde02.ent.ti.com>
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

> > This is for the Asahi Kasei AK8975 3-axis magnetometer.  It 
> resides within
> > the magnetometer section of the IIO subsystem, and 
> implements the raw
> > magn_x,y,z attributes, as well as x,y,z factory calibration 
> attributes.
> > 
> Could you help me with the datasheet details.

What do you mean by this?