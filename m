Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab0LaORl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 09:17:41 -0500
Received: from mail-pv0-f194.google.com ([74.125.83.194]:60873 "EHLO
	mail-pv0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab0LaORj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 09:17:39 -0500
X-Greylist: delayed 27553 seconds by postgrey-1.27 at vger.kernel.org; Fri, 31 Dec 2010 09:17:39 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=fHf/OBVet2YGx4Qt23ZWQWQO1DdoTMWVZ51fLiY5G3SnGndgByIpAvDccY/VzfPz4I
         GMKbWQcLueG2bBjuZlYfkoxNgrW987/vZGkSos4wPESYKGujCdPN/F2H0FnW3LiJDtVz
         AFT6waZEwxFt7lDDvR3dOZ1+VJo7QhqFqILeA=
Message-ID: <4D1DE616.7010105@gmail.com>
Date: Fri, 31 Dec 2010 06:17:58 -0800
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>, trivial@kernel.org,
        devel@driverdev.osuosl.org, linux-scsi@vger.kernel.org,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ivtv-devel@ivtvdriver.org, linux-m68k@vger.kernel.org,
        spi-devel-general@lists.sourceforge.net, linux-media@vger.kernel.org
Subject: Re: [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <20101231064515.GC3733@angua.secretlab.ca> <4D1D7DAE.7060504@gmail.com> <20101231091136.GC1886@bicker>
In-Reply-To: <20101231091136.GC1886@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2010 01:11 AM, Dan Carpenter wrote:
> On Thu, Dec 30, 2010 at 10:52:30PM -0800, Justin P. Mattock wrote:
>> On 12/30/2010 10:45 PM, Grant Likely wrote:
>>> On Thu, Dec 30, 2010 at 03:07:51PM -0800, Justin P. Mattock wrote:
>>>> The below patch fixes a typo "diable" to "disable". Please let me know if this
>>>> is correct or not.
>>>>
>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>
>>> applied, thanks.
>>>
>>> g.
>>
>> ahh.. thanks.. just cleared up the left out diabled that I had
>> thought I forgotten(ended up separating comments and code and
>> forgot)
>
> This is really just defensiveness and random grumbling and grumpiness on
> my part, but one reason I may have missed the first patch is because
> your subject lines are crap.
>
> Wrong:  [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.
>
> Right:  [PATCH 02/15] spi/dw_spi: Typo change diable to disable
>
> regards,
> dan carpenter
>

alright.. so having the backlash is alright for the subject

Thanks for the pointer on this..

Justin P. Mattock
