Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab0CSW13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 18:27:29 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:52197 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab0CSW12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 18:27:28 -0400
X-Greylist: delayed 585 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Mar 2010 18:27:27 EDT
Date: Fri, 19 Mar 2010 23:17:40 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: stefani@seibold.net, stable@kernel.org
Subject: include/linux/kfifo.h - INIT_KFIFO() broken?
Message-ID: <20100319221740.GA26455@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org, stefani@seibold.net,
	stable@kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current include/linux/kfifo.h header defines __kfifo_initializer at
line 59 and undefines it at line 105. INIT_KFIFO() uses
__kfifo_initializer so INIT_KFIFO is currently not usable unless
line 105 is removed (if I have analysed the problem correctly).

The updated kfifo patchset by Stefani Seibold seems to fix that 
particular problem, but if it isn't included in 2.6.34, then at least 
INIT_KFIFO should be fixed (and that goes for 2.6.33.X as well).

-- 
David Härdeman
