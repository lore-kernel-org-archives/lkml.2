Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933226Ab2HWHRN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 03:17:13 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:53345 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755763Ab2HWHRL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 03:17:11 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>,
        "Philip, Avinash" <avinashphilip@ti.com>
Subject: [PATCH 0/2] Support for configuring polarity of PWM
Date: Thu, 23 Aug 2012 12:30:49 +0530
Message-ID: <1345705251-10942-1-git-send-email-avinashphilip@ti.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patch set adds support for configuring polarity of eCAP & eHRPWM.

Philip, Avinash (2):
  pwm: pwm-tiecap: Add support for configuring polarity of PWM
  pwm: pwm-tiehrpwm: Add support for configuring polarity of PWM

 drivers/pwm/pwm-tiecap.c   |   22 +++++++++
 drivers/pwm/pwm-tiehrpwm.c |  104 +++++++++++++++++++++++++++++++-------------
 2 files changed, 96 insertions(+), 30 deletions(-)

