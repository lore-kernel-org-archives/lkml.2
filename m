Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758650Ab2CSJKa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 05:10:30 -0400
Received: from smtp-out-236.synserver.de ([212.40.185.236]:1105 "EHLO
	smtp-out-236.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab2CSJK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 05:10:29 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 406
Message-ID: <4F66F88F.3050804@metafoo.de>
Date: Mon, 19 Mar 2012 10:12:47 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111114 Iceowl/1.0b2 Icedove/3.1.16
MIME-Version: 1.0
To: Axel Lin <axel.lin@gmail.com>
CC: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v3 2/2] regulator: Convert pcf50633 to get_voltage_sel
References: <1332125724.17246.1.camel@phoenix> <1332125826.17246.3.camel@phoenix>
In-Reply-To: <1332125826.17246.3.camel@phoenix>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 03:57 AM, Axel Lin wrote:
> Convert pcf50633 to get_voltage_sel and then we can remove
> pcf50633_regulator_voltage_value function and move its implementation
> to pcf50633_regulator_list_voltage.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Lars-Peter Clausen <lars@metafoo.de>
