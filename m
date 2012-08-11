Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021Ab2HKKeC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Aug 2012 06:34:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab2HKKeA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Aug 2012 06:34:00 -0400
From: Hans de Goede <hdegoede@redhat.com>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] radio-shark*: Only compile led support when CONFIG_LED_CLA
Date: Sat, 11 Aug 2012 12:34:51 +0200
Message-Id: <1344681295-2485-1-git-send-email-hdegoede@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Here is the second revision of my patch-set to fix the build breakage when
the radio-shark* drivers are enabled and CONFIG_LED_CLASS is not enabled.

This new version introduces 2 new cleanup / preparation patches, and take
into account the remarks from Mauro's review of v1.

Regards,

Hans
