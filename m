Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab2KDIiw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2012 03:38:52 -0500
Received: from mail-in-13.arcor-online.net ([151.189.21.53]:32981 "EHLO
	mail-in-13.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751031Ab2KDIis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2012 03:38:48 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-16.arcor-online.net BE1DF85EB
Subject: [PATCH 0/4] HID: roccat: New functionalities and cleanup
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Rob Landley <rob@landley.net>, Jiri Kosina <jkosina@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 04 Nov 2012 09:38:46 +0100
Message-ID: <1352018326.2673.130.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

koneplus driver now supports updated model KoneXTD.
Added support for device reset for koneplus and savu drivers.
Removed a lot of unnecessary code for koneplus driver, bringing it
nearer to the looks of my newer roccat drivers.


