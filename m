Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0D0PbO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 11:31:14 -0400
Received: from loki.rshc.de ([88.198.45.163]:34018 "EHLO loki.rshc.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753672Ab0D0PbN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 11:31:13 -0400
X-Greylist: delayed 1854 seconds by postgrey-1.27 at vger.kernel.org; Tue, 27 Apr 2010 11:31:13 EDT
Message-ID: <4BD6FCDA.9080800@rshc.de>
Date: Tue, 27 Apr 2010 17:03:54 +0200
From: Sebastian Daehne <daehne@rshc.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100406 Icedove/3.0.4
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.43 - Intel KMS - rendering broken
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear All,

I have problems getting my Intel GMA HD to work properly. When loading the
i915 driver with modeset=1 the white console font is almost green and
starting X using the intel (2.10) driver results in a weird looking X. 
(Resolutions
seems correct but the colors are all wrong)

Anyone experiencing similar problems with that driver or even knows
how to fix that?

Kernel I was using:  latest git: linux/kernel/git/torvalds/linux-2.6.git

System:
  Sony Vaio VPCZ11X9E
  Intel GMA HD (Arrandale)

regards

Sebastian



