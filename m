Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754151Ab0KIJqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 04:46:01 -0500
Received: from smtp2.infomaniak.ch ([84.16.68.90]:49344 "EHLO
	smtp2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753654Ab0KIJqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 04:46:00 -0500
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Nov 2010 04:46:00 EST
Date: Tue, 09 Nov 2010 10:40:51 +0100
From: David Lutolf <david@lutolf.ch>
To: linux-kernel@vger.kernel.org
Subject: duplicate symbol
Message-ID: <1289295651-995eb1fafe32ac083b721f6ec0720266@lutolf.ch>
X-Mailer: Infomaniak Webmail
X-Origin-IP: 85.218.65.182
MIME-Version: 1.0
X-Priority: 3 (Normal)
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on smtp2 host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

in the kernel config, we can find

CS5535_GPIO (Device drivers -> Character devices)
GPIO_CS5535 (Device drivers -> GPIO support)

this looks like it should be cleaned out

regards

-David
