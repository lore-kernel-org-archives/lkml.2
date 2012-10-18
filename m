Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249Ab2JRMnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 08:43:25 -0400
Received: from www17.your-server.de ([213.133.104.17]:38283 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab2JRMnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 08:43:24 -0400
X-Greylist: delayed 1616 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Oct 2012 08:43:24 EDT
Message-ID: <1350562575.1270.3.camel@localhost.localdomain>
Subject: "read_current_timer" undefined!
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org, airlied <airlied@linux.ie>,
        "David S. Miller" <davem@davemloft.net>
Date: Thu, 18 Oct 2012 14:16:15 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

ERROR: "read_current_timer" [drivers/gpu/drm/udl/udl.ko] undefined!
ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!

"read_current_timer() is not an exported symbol so you cannot use it
from modules. This is most likely an error in the Kconfig entries for
those modules. They shouldn't be marked tristate. It seems like these
are pulled in by the get_cycles() macro that is both used in udl and
tcrypt."

kind regards
thomas

