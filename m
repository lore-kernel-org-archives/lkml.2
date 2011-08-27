Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab1H0NYg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Aug 2011 09:24:36 -0400
Received: from mail-in-10.arcor-online.net ([151.189.21.50]:53434 "EHLO
	mail-in-10.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751394Ab1H0NYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Aug 2011 09:24:35 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 9621A2D65CA
Subject: [PATCH 0/5] HID: roccat: Small fixes, cleanups and unifications
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Aug 2011 15:24:28 +0200
Message-ID: <1314451469.24216.66.camel@neuromancer.tessier-ashpool>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Main content of this patchset is the unification of profile change
reporting behaviour between roccat drivers.
Beside that some code was cleaned up a bit and two cases are fixed where
the drivers returned wrong values on certain occassions.

