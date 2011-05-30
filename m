Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab1E3MYX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 08:24:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33031 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756995Ab1E3MYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 08:24:20 -0400
Message-Id: <1306758260.29893.1457540113@webmail.messagingengine.com>
X-Sasl-Enc: 1u9yr388CoNAIP6b4hF+18wPPjioAm+fUqzLYWLXHpPh 1306758260
From: "Jack Stone" <jwjstone@fastmail.fm>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Fedora 15 and CONFIG_MODULES
Date: Mon, 30 May 2011 13:24:20 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I am seeing lots of boot messages about missing /proc/modules without
CONFIG_MODULES. Not a kernel problem - userspace is assuming that
modules are used. I was just wondering if you saw the same (only because
you are the only person I know of running without MODULES on x86).

I'm running a reasonably up-to-date Fedora 15.

Thanks for reading,

Jack

P.S.

I feel for you with the atom laptop - all I have access to at the
moment...
