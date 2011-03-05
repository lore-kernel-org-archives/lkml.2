Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447Ab1CETHc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 14:07:32 -0500
Received: from thelittlecloset.ca ([64.40.149.83]:56575 "EHLO plecavalier.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483Ab1CETHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 14:07:31 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Mar 2011 14:07:30 EST
Content-Type: text/plain; charset=UTF-8
Subject: Second drive on VT6421
From: Philippe LeCavalier <support@plecavalier.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 05 Mar 2011 14:00:44 -0500
Message-Id: <1299350988-sup-2113@plc.intranet.plecavalier.com>
User-Agent: Sup/0.12.1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I know it's been discussed but since it's been a while, has anyone
managed to get a second drive detected with this card?

I'm on Deb Squeeze with 2.6.32-5

sata_via is loading fine and I can see the drives if they're connected
individually but not if I connect both. If I do connect both I only see
one of them -which is always from the same port-.

To be clear, I'm not referring to the eSATA port. I'm not up to that
yet.
-- 
Thanks,
Phil
