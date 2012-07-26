Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab2GZO5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 10:57:09 -0400
Received: from mail1.matrix-vision.com ([78.47.19.71]:39696 "EHLO
	mail1.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2GZO5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 10:57:07 -0400
Message-ID: <50115B72.2070604@matrix-vision.de>
Date: Thu, 26 Jul 2012 17:00:02 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regulator: grammar fix in Kconfig
References: <1343311644-19739-1-git-send-email-michael.jones@matrix-vision.de> <1343311644-19739-3-git-send-email-michael.jones@matrix-vision.de> <20120726144812.GN3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726144812.GN3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MV-Disclaimer: true (erinome)
X-AV-Checked: ClamAV using ClamSMTP (erinome)
X-AV-Checked: ClamAV using ClamSMTP (mail1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 04:48 PM, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 04:07:24PM +0200, Michael Jones wrote:
>
>> -	  constraints then the regulator core will provide an always
>> -	  enabled dummy regulator will be provided, allowing consumer
>> -	  drivers to continue.
>> +	  constraints, the regulator core will provide an always-
>> +	  enabled dummy regulator, allowing consumer drivers to continue.
>
> This appears to be making the grammar worse, it's just removing a "then"
> and inserting, random commas which don't make, much sense.
>

What I was trying to fix was the double "provide" in "will provide an... 
will be provided."  I agree that the if...then... was ugly, too.

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
