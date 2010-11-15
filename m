Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab0KOUcp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 15:32:45 -0500
Received: from mail-in-15.arcor-online.net ([151.189.21.55]:57406 "EHLO
	mail-in-15.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752113Ab0KOUco (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 15:32:44 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-02.arcor-online.net 03D1130856
Subject: [PATCH 0/3] HID: roccat: finishing usage of
 sysfs_create_bin_group()
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 15 Nov 2010 21:32:41 +0100
Message-ID: <1289853161.2188.44.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches are against the newest roccat file versions (after
applying everything I released the last days).
They fix some inattentive (though not critical) failures from previous
patches and change hid-roccat-koneplus and hid-roccat-pyra to use the
new sysfs_create_bin_group()
koneplus should be finished now (until I find errors)

Stefan

