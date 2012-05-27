Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766Ab2E0HHt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 03:07:49 -0400
Received: from 188-142-86-119.FTTH.ispfabriek.nl ([188.142.86.119]:36754 "EHLO
	srv2.net.home" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750798Ab2E0HHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 03:07:48 -0400
X-Greylist: delayed 629 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 May 2012 03:07:48 EDT
Message-ID: <1338101838.14619.12.camel@vovan.net.home>
Subject: unable to boot with 3.4.0
From: Vladimir Elisseev <vovan@vovan.nl>
To: linux-kernel@vger.kernel.org
Date: Sun, 27 May 2012 08:57:18 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

After upgrading to vanilla 3.4.0 system is unable to boot: system hangs
almost instantly after boot with fancy flashing screen (it looks like
video card is broken). Passing any pcie_aspm parameters doesn't help.
Though I'm able to boot 3.4.0 using working kernel and then kexec'ing to
3.4.0. I had exactly the same symptoms with 3.2.12, 3.2.13, and 3.3.0,
so I thought it's related to
https://bugzilla.kernel.org/show_bug.cgi?id=42979 , but Jonathan
(jrnieder@gmail.com) suggested to sent email to this mailing list.

Regards,
Vlad.

