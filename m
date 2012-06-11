Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab2FKSJv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:09:51 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:56588 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab2FKSJs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:09:48 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: axel.lin@gmail.com
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT 2/2] regulator: max1586: Convert max1586_v3_ops to set_voltage_sel and map_voltage_linear
References: <1339115141.4310.3.camel@phoenix>
	<1339115204.4310.4.camel@phoenix> <877gvfvxyd.fsf@free.fr>
	<CAF+7xWm_C5tZaXPsH3944_f-h4vuvRb1MorPuTB0fWTVhT9RPA@mail.gmail.com>
X-URL: http://belgarath.falguerolles.org/
Date: Mon, 11 Jun 2012 20:09:39 +0200
Message-ID: <87txyhvhy4.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> 2012/6/11 Robert Jarzmik <robert.jarzmik@free.fr>:
>> Axel Lin <axel.lin@gmail.com> writes:
> I think all the necessary patches are already in linux-next tree.
> I have no problem to build it with linux-next 20120608.

OK, my fault, build problem.
I tested this serie with the PXA VCC-core regulation, it's fine.

Please have my :
Acked-by: Robert Jarzmik <robert.jarzmik@free.fr>

Cheers.

-- 
Robert
