Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755190Ab0INWYf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:24:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56268 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752529Ab0INWYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:24:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/2] PM / Hibernate: Default image size computation and comment fix
Date: Wed, 15 Sep 2010 00:21:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc4-rjw+; KDE/4.4.4; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009150021.45101.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following two patches fix a comment in the hibernate memory preallocation
code and make the default image size depend on the total RAM size.  I regard
them as 2.6.37 material.

Please let me know if there are any objections.

Thanks,
Rafael

