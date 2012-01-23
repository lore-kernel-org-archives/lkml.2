Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab2AWJd5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 04:33:57 -0500
Received: from ams-iport-2.cisco.com ([144.254.224.141]:30476 "EHLO
	ams-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2AWJd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 04:33:56 -0500
X-IronPort-AV: E=Sophos;i="4.71,555,1320624000"; 
   d="scan'208";a="64350105"
From: Hans Verkuil <hansverk@cisco.com>
Organization: Cisco Systems Norway
To: Axel Lin <axel.lin@gmail.com>
Subject: Re: [PATCH] [media] convert drivers/media/* to use module_i2c_driver()
Date: Mon, 23 Jan 2012 10:33:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.2-0.slh.2-aptosid-amd64; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Heungjun Kim <riverful.kim@samsung.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Andrew Chew <achew@nvidia.com>, Paul Mundt <lethal@linux-sh.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Johannes Obermaier <johannes.obermaier@gmail.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Steven Toth <stoth@kernellabs.com>, linux-media@vger.kernel.org
References: <1327140645.3928.1.camel@phoenix>
In-Reply-To: <1327140645.3928.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201201231033.30369.hansverk@cisco.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For modules:

adv7170
adv7175
bt819
bt856
bt866
cs5345
cx53l32a
cx25840-core
indycam
ks0127
m52790
msp3400-driver
saa6588
saa6752hs
saa7110
saa7115
saa7127
saa717x
saa7191
tda7432
tda9840
tea6415c
tea6420
tlv320aic23b
tuner-core
tvaudio
upd64031a
upd64083
vp27smpx
wm8739
wm8775

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans
