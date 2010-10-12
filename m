Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab0JLIYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 04:24:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55625 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756888Ab0JLIYv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 04:24:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:x-mailer;
        b=KF1C5B1bShy0zUUd0LsezXNopBl1/38GCHLz4AMzF3JDrw6kmOBP1zSPTGqvus9AwP
         iG16KTSXEZSLkbP3p+eacLb2RBREL/I9c0AfC6CADIRIa+2rrnzzIWhWBWMjP1GksYl5
         1BlUqucTf4E/NfWAOglG49c95XM4qjtR9KUE8=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Vasiliy Kulikov <segooon@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] staging ft1000-usb code cleanup patches. 
Date: Tue, 12 Oct 2010 10:26:39 +0200
Message-Id: <1286872003-12449-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This set of patches clean ft1000-usb driver from various problems like
typedef usage, memory leaks and unused comments.
