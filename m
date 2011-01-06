Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab1AFIBO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 03:01:14 -0500
Received: from mail-in-04.arcor-online.net ([151.189.21.44]:35891 "EHLO
	mail-in-04.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751599Ab1AFIAc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 03:00:32 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-11.arcor-online.net 3304835A592
Subject: [PATCH 0/2] HID: roccat: Add support for Arvo, small bugfix and a
 question
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 Jan 2011 09:00:29 +0100
Message-ID: <1294300829.5622.57.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset adds support for the Roccat Arvo keyboard.
The driver is similar to my other roccat drivers.

I'm now finished implementing new device support and my next
step would be to abstract similarities to reduce code duplication.

Has the resulting file to be a module named like "roccat-common"
that has to be selected as depencendy in Kconfig or is there
another mechanism to hide this gratuitous decicion from the user?

Second part of this patchset fixes a non vital glitch in koneplus.


