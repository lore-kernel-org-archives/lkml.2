Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab2LEAig (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 19:38:36 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39785 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab2LEAhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 19:37:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Len Brown <lenb@kernel.org>
Subject: [PATCH 0/3] ACPI / PM: Export ACPI power states of devices via sysfs
Date: Wed, 05 Dec 2012 01:39:26 +0100
Message-ID: <1464990.iyrX0DeZyT@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc8; KDE/4.9.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

In some situations it is very useful to know the current ACPI power states of
devices.  For this reason, the following series of patches makes it possible
to retrieve that information via sysfs.

Patches [1-2/3] are trivial function renames, patch [3/3] is the real thing.

The series is on top of the master branch of linux-pm.git.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
