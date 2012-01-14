Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2ANBj1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 20:39:27 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48900 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab2ANBj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 20:39:26 -0500
MIME-Version: 1.0
Date: Fri, 13 Jan 2012 19:39:25 -0600
Message-ID: <CAPbJ=BnQoWJUsbc-i9S_JLvc_qfnDuSt=cBqr6GvkUkWfQemkA@mail.gmail.com>
Subject: [RFC][PATCH 0/2] hwmon: (w83627ehf) Adds GPIO port 3 functionality
From: Alex Rio <scasbyte@gmail.com>
To: khali@linux-fr.org, guenter.roeck@ericsson.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series enable the GPIO port 3 and exposes the functions set/get
pin value, direction in/out, debounce enable/disable. This series
stick to the gpio.h conventions. All features are also available (if
requiered) to the user-space in the path /sys/class/gpio.
It has been tested to be working.

Alex Rio (2):
  hwmon: (w83627ehf) Replace deprecated function strict_strto*
  hwmon: (w83627ehf) Add GPIO port 3 functionality

 drivers/hwmon/w83627ehf.c |  210 ++++++++++++++++++++++++++++++++++++++++++---
 1 files changed, 199 insertions(+), 11 deletions(-)
