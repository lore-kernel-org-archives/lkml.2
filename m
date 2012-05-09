Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932456Ab2EIVib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 17:38:31 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34530 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932246Ab2EIVi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 17:38:28 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [RFC][PATCH 0/2] PM / Domains / cpuidle: Preliminary cpuidle support for generic PM domains
Date: Wed, 9 May 2012 23:40:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Colin Cross <ccross@android.com>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205092340.26561.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Since people have been spending quite some time on cpuidle recently,
I thought it might be a good time to show some ideas about how to make cpuidle
work along with the generic PM domains framework (and the other way around).

The first patch is just an addition that's used by the second one.  The
second patch is not functional code and untested, so it is for comments only
right now (no signoff), although I did my best to make is as close to
functional as possible.

The details are in the changelogs, please tell me what you think.

Thanks,
Rafael

