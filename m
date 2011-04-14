Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1DNWcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 18:32:12 -0400
Received: from eazy.amigager.de ([213.239.192.238]:51731 "EHLO
	eazy.amigager.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925Ab1DNWcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 18:32:09 -0400
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Thu, 14 Apr 2011 18:32:09 EDT
Date: Fri, 15 Apr 2011 00:25:25 +0200
From: Tino Keitel <tino.keitel@tikei.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: /proc/acpi/wakeup regression in 2.6.39-rc3
Message-ID: <20110414222525.GA24365@mac.home>
Mail-Followup-To: "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

with 2.6.38, I enabled wakeup from suspend to RAM with the USB keyboard
this way:

echo USB2 > /proc/acpi/wakeup

This does not work anymore with 2.6.39-rc3. Wakeup using the keyboard
won't work, and the USB2 line in /proc/acpi/wakeup doesn't change to
"enabled" after the echo command.

Is this intended? If yes, what is the new way to enable keyboard
wakeup?

Regards,
Tino
