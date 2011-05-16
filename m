Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab1EPOHm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:07:42 -0400
Received: from 10.26.mail-out.ovh.net ([46.105.47.155]:34272 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1755358Ab1EPOHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:07:41 -0400
X-Greylist: delayed 1240 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 May 2011 10:07:41 EDT
From: fabien.marteau@armadeus.com
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hwmon: Driver for as1531, Austria-Microsystem Analog to Digital Converter. 
Date: Mon, 16 May 2011 15:39:13 +0200
Message-Id: <1305553154-18195-1-git-send-email-fabien.marteau@armadeus.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <fabien.marteau@armadeus.com>
References: <fabien.marteau@armadeus.com>
X-Ovh-Tracer-Id: 2959709380370129173
X-Ovh-Remote: 82.232.255.99 (arc68-6-82-232-255-99.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

This is the driver of as1531 analog to digital chip we use on our ARMadeus platform.

