Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447Ab1CaMaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 08:30:08 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51764 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab1CaMaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 08:30:07 -0400
From: Michal Simek <monstr@monstr.eu>
To: devicetree-discuss@lists.ozlabs.org
Cc: grant.likely@secretlab.ca, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, hjk@linutronix.de, gregkh@suse.de
Subject: UIO OF support
Date: Thu, 31 Mar 2011 14:29:59 +0200
Message-Id: <1301574600-4861-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

here is OF support for UIO. I tried to do minimal changes.
John Williams has warned me that there was any previous attempt to add this OF support 
to UIO.

Grant: Can you please review it? I wasn't sure about one part. I think you will see it 
and will comment it if there is something stupid.

I look forward for your comments and discuss about it.

Thanks,
Michal



