Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab3ABKFS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 05:05:18 -0500
Received: from mail-ee0-f53.google.com ([74.125.83.53]:49643 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752422Ab3ABKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 05:05:16 -0500
Message-ID: <50E404BC.3010604@monstr.eu>
Date: Wed, 02 Jan 2013 10:58:20 +0100
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Lars-Peter Clausen <lars@metafoo.de>, netdev@vger.kernel.org
CC: Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, John Linn <linnj@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>
Subject: Support for Marvell 88E1510 and 88E1116R
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi guys,

just a question regarding to Marvell 88e1510 and 88E1116R phys.
We have these phys on the arm zynq board and would like to add
support to the kernel. Is there any repository with these phys?
If yes, when are you going to add them to the mainline?

If there is not, I can send patches for them.
(I am not the author of that patches just trying to clean our
repository and add patches to the mainline)

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
