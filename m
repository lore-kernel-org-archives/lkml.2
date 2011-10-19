Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1JSWNE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 18:13:04 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:51290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754977Ab1JSWNA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 18:13:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-sh list" <linux-sh@vger.kernel.org>
Subject: [PATCH 0/3] Support for A3SP and A4R domains on SH7372
Date: Thu, 20 Oct 2011 00:12:43 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc9+; KDE/4.6.0; x86_64; ; )
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201110200012.43840.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Patches [2/3] and [3/3] add support for the SH7372's A3SP and A4R power
domains, respectively.

Patch [1/3] is a fix that's needed for console wakeup to work with the
A3SP domain patch.

Thanks,
Rafael

