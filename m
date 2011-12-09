Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab1LIXVF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 18:21:05 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:51369 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1LIXVB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 18:21:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/4] PM: Make the PM core execute driver callbacks if subsystem ones are not present
Date: Sat, 10 Dec 2011 00:18:38 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201112100018.38536.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patchset changes the PM core so that driver callbacks
are executed automatically when subsystem ones are not present and
uses the new PM core's behavior to simplify the platform and AMBA bus
types (there probably are many more bus types that may be simplified
this way, but those two were the easiest targets for me).

The reasons why to do this are outlined in the changelog of the second patch.

Comments welcome!

Thanks,
Rafael

