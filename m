Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035Ab0LaR7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 12:59:02 -0500
Received: from mail-pz0-f66.google.com ([209.85.210.66]:51243 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753721Ab0LaR67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 12:58:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=v+X8RlgtAHXl5EH78SLcKGgX0mU3ic0rTMXF12hGE0909Kx+mV+TK1D4tvV57gbnqO
         wnLVVdQmtkIApT6uTt8RFvnbolc0tkCnChrJtdXFWaV2t0KElk0P53ant45s1BT50dGN
         fqs6fHQuRUQzqxeNtzToI+Gk2pCR4tNzTJpnY=
Message-ID: <4D1E19F7.6000608@gmail.com>
Date: Fri, 31 Dec 2010 09:59:19 -0800
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
References: <1293750484-1161-1-git-send-email-justinmattock@gmail.com> <1293750484-1161-2-git-send-email-justinmattock@gmail.com> <20101231064515.GC3733@angua.secretlab.ca> <4D1D7DAE.7060504@gmail.com> <20101231091136.GC1886@bicker> <4D1DE616.7010105@gmail.com> <20101231174100.GF1886@bicker>
In-Reply-To: <20101231174100.GF1886@bicker>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/31/2010 09:41 AM, Dan Carpenter wrote:
> On Fri, Dec 31, 2010 at 06:17:58AM -0800, Justin P. Mattock wrote:
>>> Wrong:  [PATCH 02/15]drivers:spi:dw_spi.c Typo change diable to disable.
>>>
>>> Right:  [PATCH 02/15] spi/dw_spi: Typo change diable to disable
>>>
>>> regards,
>>> dan carpenter
>>>
>>
>> alright.. so having the backlash is alright for the subject
>
> Well really my point is not so much about backslashes vs colons, it's
> about getting the *one* correct prefix.  This stuff is probably
> scriptable most of the time, but you may still be required to think a
> little on the corner cases.
>
> Here is a script to get you started.
>
> git log --format="%s" drivers/spi/dw_spi.c | \
> 	head -n 20 |                         \
> 	perl -ne 's/(.*):.*/$1/; print' |    \
> 	sort | uniq -c | sort -rn |          \
> 	perl -ne 's/^\W+\d+ //; print' |     \
> 	head -n 1
>
> regards,
> dan carpenter
>

thats a nice little script there(just ran it) any way you want to add 
this into to getmaintainers.pl or something? (this way people get the 
maintainers address plus a subject line in the mix)

Justin P. Mattock
