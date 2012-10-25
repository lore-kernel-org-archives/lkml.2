Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751430Ab2JYVV6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 17:21:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45273 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab2JYVVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 17:21:35 -0400
From: Benson Leung <bleung@chromium.org>
To: mjg@redhat.com, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org, corentin.chary@gmail.com
Cc: bleung@chromium.org, olofj@chromium.org, olof@lixom.net
Subject: [PATCH v2 0/1] Platform: x86: Add Chrome OS Laptop driver
Date: Thu, 25 Oct 2012 14:21:20 -0700
Message-Id: <1351200081-19349-1-git-send-email-bleung@chromium.org>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1341961393-17728-1-git-send-email-bleung@chromium.org>
References: <1341961393-17728-1-git-send-email-bleung@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spun another version of this patch. Thanks Coretin for your feedback.
I've incorporated your suggestions.

v2 : * Added MODULE_DEVICE_TABLE for the dmi table.
     * Made __init and __initdata position consistent across this file.
     * Made prefix static const char *
     * Made strncmp expressions more explicit
     * Added an additional match for DMI_SYS_VENDOR for Samsung Lumpy.

Benson

