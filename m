Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2GZP0U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:26:20 -0400
Received: from mail2.matrix-vision.com ([85.214.244.251]:45755 "EHLO
	mail2.matrix-vision.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313Ab2GZP0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:26:19 -0400
Message-ID: <5011624A.4040309@matrix-vision.de>
Date: Thu, 26 Jul 2012 17:29:14 +0200
From: Michael Jones <michael.jones@matrix-vision.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] regulator: whitespace
References: <1343311644-19739-1-git-send-email-michael.jones@matrix-vision.de> <1343311644-19739-2-git-send-email-michael.jones@matrix-vision.de> <20120726144457.GM3099@opensource.wolfsonmicro.com> <50115E7B.3010400@matrix-vision.de> <20120726151546.GQ3099@opensource.wolfsonmicro.com>
In-Reply-To: <20120726151546.GQ3099@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MV-Disclaimer: true (erinome)
X-AV-Checked: ClamAV using ClamSMTP (erinome)
X-AV-Checked: ClamAV using ClamSMTP (mail2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2012 05:15 PM, Mark Brown wrote:
> On Thu, Jul 26, 2012 at 05:12:59PM +0200, Michael Jones wrote:
>> On 07/26/2012 04:44 PM, Mark Brown wrote:
>
>>> Your changelog says "whitespace" and is otherwise blank...  what is the
>>> problem you think you are fixing here?
>
>> I don't see what you're seeing.
>
> I'm not seeing anything at all.  That's the problem.
>
>> Here:
>> https://lkml.org/lkml/2012/7/26/255
>> I see the patch which replaces non-uniform spaces with tabs.
>
> ...and only has a one word changelog.
>

Sorry, I misunderstood.  I thought you saw _only_ a one word change log, 
and not even the patch.  I think I answered your question above now, right?
Q: what is the problem you think you are fixing here?
A: some lines were indented with spaces, while most of them are indented 
with tabs.

So I suppose the changelog should have been something like:
regulator: whitespace- indent with tabs not spaces

MATRIX VISION GmbH, Talstrasse 16, DE-71570 Oppenweiler
Registergericht: Amtsgericht Stuttgart, HRB 271090
Geschaeftsfuehrer: Gerhard Thullner, Werner Armingeon, Uwe Furtner, Erhard Meier
