Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab2JAUWm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:22:42 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:63404 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281Ab2JAUWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:22:40 -0400
MIME-Version: 1.0
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 1 Oct 2012 14:22:19 -0600
Message-ID: <CAErSpo7SxK8F_M0kfRRr0k23UVNCtZXpMkcsGY3mJ_qsx3KBkw@mail.gmail.com>
Subject: Duplicate sysfs file: microamps_requested_vmmc
To: Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an old bug report I'd like to close out.  Do you guys know
anything about it?  I couldn't even find the
"microamps_requested_vmmc" string in the v3.6 kernel, so I suspect
it's obsolete.

https://bugzilla.kernel.org/show_bug.cgi?id=35142

Hardware name: Qosmio E10
sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:1e.0/0000:02:0b.4/microamps_requested_vmmc'
