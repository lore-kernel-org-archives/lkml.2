Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab1FHNYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 09:24:03 -0400
Received: from i88.de ([88.198.25.141]:37621 "EHLO mail.i88.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab1FHNYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 09:24:01 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Jun 2011 09:24:00 EDT
Date: Wed, 8 Jun 2011 15:16:34 +0200
From: "Micha M." <linux-kernel@mail.i88.de>
To: linux-kernel@vger.kernel.org
Subject: Calling code
Message-ID: <20110608131634.GA13434@mailer.i88.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-message-flag: If you can't read the body, then you should change your
 mail user agent! Outlook sucks!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I'd like to know if it is possible to jump to a certain address, run code
from there and then return to the kernel-module (the caller). That code is
located somewhere in the physical address space and uses (internal) also
physical addesses. I tried to ioremap that function, but unfortunatly I
got some page faults causing an Oops. I realized that this approach will
not work regarding the fixed and absolute addresses in the code.

So is there a way to jump to a certain address, run code from there and
after execution return to the caller? I would prefere a way without
assembly :-)



Regards,

#micha


-- 
/* To err is human; to really fuck things up requires the root password */
