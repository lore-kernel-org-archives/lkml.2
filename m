Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228Ab0I2HCS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:02:18 -0400
Received: from mailhost-o3-m2.nerim-networks.com ([78.40.49.187]:49858 "EHLO
	smtp-delay2.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751408Ab0I2HCQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:02:16 -0400
Date: Wed, 29 Sep 2010 09:01:53 +0200
From: Damien Wyart <damien.wyart@free.fr>
To: linux-kernel@vger.kernel.org
Subject: High CPU load when machine is idle
Message-ID: <20100929070153.GA2200@brouette>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

With 2.6.36-rc6, I'm seeing a load of around 0.60 when the machine is
completely idle. This is similar to what someone reported for the latest
2.6.35.x stables. This is on a core i7 machine, but I've no time to
bisect or test earlier versions right now, but I guess this is easy to
reproduce on the same plateform.


Best,
-- 
Damien Wyart
