Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab1CGX1N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 18:27:13 -0500
Received: from adelie.canonical.com ([91.189.90.139]:60510 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168Ab1CGX1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 18:27:08 -0500
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>
Subject: [PATCH] thinkpad-acpi: module autoloading for newer Lenovo ThinkPads.
Date: Mon,  7 Mar 2011 17:26:46 -0600
Message-Id: <1299540407-3779-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Please consider the following patch that adds support for auto loading 
thinkpad_acpi module on newer Lenovo ThinkPads that have HKEY HID set 
to LEN0068 instead of IBM0068. 

==== dsdt.dsl =============================================
                    Device (HKEY)
                    {
                        Name (_HID, EisaId ("LEN0068"))
                        Method (_STA, 0, NotSerialized)
                        {
                            Return (0x0F)
                        }
============================================================

This patch was tested on a Lenovo x120e. 

Thank you
Manoj Iyer

