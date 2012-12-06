Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753971Ab2LFAse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 19:48:34 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55449 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab2LFAsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 19:48:32 -0500
From: Benson Leung <bleung@chromium.org>
To: dmitry.torokhov@gmail.com, rydberg@euromail.se,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bleung@chromium.org, djkurtz@chromium.org, olofj@chromium.org,
        dudl@cypress.com
Subject: [PATCH v2 0/1] Input: add driver for Cypress APA I2C Trackpad
Date: Wed,  5 Dec 2012 16:48:18 -0800
Message-Id: <1354754899-26701-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341959357-14691-1-git-send-email-bleung@chromium.org>
References: <1341959357-14691-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the patience on this driver. I have stripped out firmware update,
the sysfs properties around firmware version, hardware version, update_fw,
and power state.

I have incorporated rydberg's suggestions for cleanup.

