Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab2IFF2o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 01:28:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33282 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab2IFF2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 01:28:43 -0400
From: "Philip, Avinash" <avinashphilip@ti.com>
To: <thierry.reding@avionic-design.de>
CC: <linux-kernel@vger.kernel.org>, <nsekhar@ti.com>, <gururaja.hebbar@ti.com>
Subject: [PATCH V2 0/2] Support for configuring polarity of PWM
Date: Thu, 6 Sep 2012 10:40:01 +0530
Message-ID: <1346908203-10632-1-git-send-email-avinashphilip@ti.com>
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

 drivers/pwm/pwm-tiecap.c   |   22 +++++++++++++
 drivers/pwm/pwm-tiehrpwm.c |   72 +++++++++++++++++++++++++++++++-------------
 2 files changed, 73 insertions(+), 21 deletions(-)

