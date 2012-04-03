Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574Ab2DCPEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 11:04:50 -0400
Received: from newsmtp5.atmel.com ([204.2.163.5]:22412 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab2DCPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 11:04:48 -0400
Message-ID: <4F7B1174.5070300@atmel.com>
Date: Tue, 03 Apr 2012 17:04:20 +0200
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, plagnioj@jcrosoft.com
CC: linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        ludovic.desroches@atmel.com, linux-kernel@vger.kernel.org,
        arnd@arndb.de, olof@lixom.net
Subject: Re: [PATCH v2 06/13] USB: ohci-at91: change maximum number of ports
References: <Pine.LNX.4.44L0.1204030954590.1537-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1204030954590.1537-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 04:11 PM, Alan Stern :
> On Tue, 3 Apr 2012, Nicolas Ferre wrote:
> 
>> Change number of ports to 3 for newer SoCs. Modify pdata structure
>> and ohci-at91 code that was dealing with ports information and check
>> of port indexes.
>>
>> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>> Acked-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
> 
> Did you run this patch through scripts/checkpatch.pl?  I have the 
> feeling that it might complain about some of the changes.

Yes, definitively.

I can modify the patch to comply with error issued by checkpatch.pl: several are
due to a bad replacement of previous code with my regular expression but others
where existing before my modifications.
So what do you think about:
 - addressing all style errors in this patch (to prevent carrying them)
 - merging this one and the following patch:
   "[PATCH v2 07/13] USB: ohci-at91: coding style modifications with one-line ifs
 - posting a v3 of this patch only if you agree on this...

Best regards,
-- 
Nicolas Ferre
