Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab1K3VHk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 16:07:40 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:16047 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752976Ab1K3VHi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 16:07:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 30 Nov 2011 13:07:33 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Rakesh Iyer <riyer@nvidia.com>,
        "dmitry.torokhov@gmail.com" <dmitry.torokhov@gmail.com>
CC: "rydberg@euromail.se" <rydberg@euromail.se>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Wed, 30 Nov 2011 13:07:13 -0800
Subject: RE: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Thread-Topic: [PATCH v1] Input: tegra-kbc - report wakeup key for some
 platforms.
Thread-Index: AcyvoMDPHO1cXi9EQr6YIFY7VUZQaAAAzUnA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF174FDAFF82@HQMAIL01.nvidia.com>
References: <1322685811-14060-1-git-send-email-riyer@nvidia.com>
In-Reply-To: <1322685811-14060-1-git-send-email-riyer@nvidia.com>
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

Rakesh Iyer wrote at Wednesday, November 30, 2011 1:44 PM:
> Tegra kbc cannot detect exact keypress causing wakeup in interrupt mode.
> Allow wakeup keypress to be reported for certain platforms.
> 
> Signed-off-by: Rakesh Iyer <riyer@nvidia.com>

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

