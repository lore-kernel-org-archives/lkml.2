Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885Ab2BOUAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 15:00:36 -0500
Received: from fep27.mx.upcmail.net ([62.179.121.47]:44910 "EHLO
	fep27.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751924Ab2BOUAf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 15:00:35 -0500
X-Greylist: delayed 1115 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Feb 2012 15:00:34 EST
X-SourceIP: 178.83.228.246
X-Authenticated-Sender: odi.ch@hispeed.ch
Message-ID: <4F3C0A96.3050105@odi.ch>
Date: Wed, 15 Feb 2012 20:42:14 +0100
From: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: regulators: dummy.c vs. REGULATOR_DUMMY
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have REGULATOR_DUMMY unset, but still get the dummy regulator registered. As 
far as I can see, dummy.c is always built regardless of the config option. 
Either the option should be removed or the Makefile should be changed to 
actually use it.

Thanks,

Ortwin
