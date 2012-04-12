Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695Ab2DLUav (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:30:51 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:35523 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754900Ab2DLUat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:30:49 -0400
Message-ID: <4F873B5D.7010309@ahsoftware.de>
Date: Thu, 12 Apr 2012 22:30:21 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Sergio Correia <lists@uece.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sujith Manoharan <c_manoha@qca.qualcomm.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 00/78] 3.3.2-stable review
References: <20120411231102.GA6404@kroah.com> <CAJyhjX2KrfSJW64PJMTHou9zSojsfA1iNT-WahinfMBce_B=BA@mail.gmail.com> <20120412002927.GA23167@kroah.com> <4F8733C1.7020305@ahsoftware.de> <20120412200606.GA23764@kroah.com>
In-Reply-To: <20120412200606.GA23764@kroah.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 12.04.2012 22:06, schrieb Greg KH:
> On Thu, Apr 12, 2012 at 09:57:53PM +0200, Alexander Holler wrote:
>> Hello,
>>
>> Am 12.04.2012 02:29, schrieb Greg KH:
>>
>>>> is there any chance for this one to be included in this review cycle?
>>>>
>>>> http://www.spinics.net/lists/linux-wireless/msg87999.html
>>>
>>> Have you read Documentation/stable_kernel_rules.txt?  Based on that, I
>>> don't think it can, yet, right?
>>
>> Hmm, after reading that, I think the text could need an update about
>> how to submit patches written by others (which can already be found
>> in the upstream tree).
>>
>> At least for me the text reads like only the authors can request
>> inclusion of a patch into the stable tree.
>
> Patches are always welcome, but I think you will find the file already
> describes this (hint, the first '-' line for the Procedure section
> handles it).

That reads:

"- Send the patch, after verifying that it follows the above rules, to
    stable@vger.kernel.org.  You must note the upstream commit ID in the
    changelog of your submission, as well as the kernel version you wish
    it to be applied to."

Maybe I'm a bit dumb, but what would be my changelog if the patch was 
written by someone else (and e.g. fixes something the author wasn't 
aware of or hasn't described)?

Sorry, but I don't understand "changelog" in that context. Should I 
modify the (description of the) patch?

Regards,

Alexander
