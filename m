Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab3ABQHD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:07:03 -0500
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:59741 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752793Ab3ABQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:06:59 -0500
Message-ID: <50E45B74.70301@metafoo.de>
Date: Wed, 02 Jan 2013 17:08:20 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Icedove/3.0.11
MIME-Version: 1.0
To: monstr@monstr.eu
CC: netdev@vger.kernel.org, Christian Hohnstaedt <chohnstaedt@innominate.com>,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>, John Linn <linnj@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sam Bobrowicz <SBobrowicz@digilentinc.com>,
        Rick Hoover <RHoover@digilentinc.com>,
        Steven Wang <steven.wang@digilentinc.com>
Subject: Re: Support for Marvell 88E1510 and 88E1116R
References: <50E404BC.3010604@monstr.eu>
In-Reply-To: <50E404BC.3010604@monstr.eu>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 10:58 AM, Michal Simek wrote:
> Hi guys,
> 
> just a question regarding to Marvell 88e1510 and 88E1116R phys.
> We have these phys on the arm zynq board and would like to add
> support to the kernel. Is there any repository with these phys?
> If yes, when are you going to add them to the mainline?
> 
> If there is not, I can send patches for them.
> (I am not the author of that patches just trying to clean our
> repository and add patches to the mainline)

I think the 88E1510 support was added by the Digilent guys (added to Cc) and
the 88E1116R support came from within Xilinx.

I agree that these are pretty straight forward changes and could go upstream in
their current form.

- Lars
