Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0LUQwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 11:52:14 -0500
Received: from server655-han.de-nserver.de ([85.158.177.45]:49537 "EHLO
	server655-han.de-nserver.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857Ab0LUQwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 11:52:13 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 21 Dec 2010 11:52:13 EST
Message-ID: <4D10D9AD.10102@profihost.ag>
Date: Tue, 21 Dec 2010 17:45:33 +0100
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; de; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: s.priebe@profihost.ag
Subject: general protection fault: 0000 [#1] SMP in 2.6.32.27?
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-User-Auth: Auth by s.priebe@profihost.ag through 85.158.179.66
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi list,

since a few weeks we have server system which crashes from time to time. 
We then upgraded from vanilla 2.6.32.22 to 2.6.32.27 but the same 
crashes are still happening. We also replaced the whole hardware (except 
the disks) still the same crash.

The system itself is just a normal LAMP system nothing special.

Here is what i got via netconsole from each crash (i hope to use pastbin 
is OK):
http://pastebin.com/hNd15E8K

Please CC me in each mail.

Thanks and regards,
Stefan
