Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754477Ab0CVJpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 05:45:47 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:39086 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab0CVJpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 05:45:45 -0400
X-SENDER-IP: [83.226.248.59]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al1BAL7YpktT4vg7PGdsb2JhbACBO4QsgXeTWAEBAQE3uX+EfQQ
X-IronPort-AV: E=Sophos;i="4.51,286,1267398000"; 
   d="scan'208";a="53992163"
Message-ID: <4BA73C4C.4020708@coyote.org>
Date: Mon, 22 Mar 2010 10:45:48 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100322 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
References: <1269210658-9518-1-git-send-email-lindley@coyote.org> <4BA71949.9040809@cs.helsinki.fi>
In-Reply-To: <4BA71949.9040809@cs.helsinki.fi>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-22 08:16, Pekka Enberg wrote:
> Lars Lindley kirjoitti:
>> I fixed the checkpatch things except a couple of long lines.
>> I also removed hungarian notation from the argument names
>> and some "commented away" code.
>>
>> Signed-off-by: Lars Lindley <lindley@coyote.org>
> 
> Did you check that all these function declarations are actually used?
> I've spotted plenty of dead code in the past.
> 
Nope, didn't check that. Just looking at the style now..

>> +/*
>> + * ====================================
>> + * Interface function declare
>> + * ====================================
>> + */
>> +unsigned char Wb35Reg_initial(struct hw_data *HwData);
> 
> Lets avoid CamelCase for the arguments so "hw_data" here, for example. I
> see the same thing elsewhere in this patch as well.
> 
I thought struct hw_data *hw_data looked a bit confusing..Thats why I left
CamelCase alone for now. I can make it like that if you want..

/Lars
