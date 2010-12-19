Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0LSWVY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:21:24 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49168 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757218Ab0LSWVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:21:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=phXKpNFi4L6Gko3sL8Iv5lLSw+ieaEu0k1pLuoZzpTlx6FB0NvICMTGIqsoWchKQIs
         SJIuY8wZ//Z9Lm2shbLyhVAI+o42HTP/BZyh9To0HLc0qr1EEjL3fLLlXB+wB/kdsZoY
         pnLdbFSvtcSLvzMPq+a2Z1XvgIM0AboaizSnk=
Message-ID: <4D0E855F.6040009@gmail.com>
Date: Sun, 19 Dec 2010 17:21:19 -0500
From: Ric Wheeler <ricwheeler@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Eric Sandeen <sandeen@sandeen.net>
CC: Justin Piszcz <jpiszcz@lucidpixels.com>,
        Sandon Van Ness <sandon@van-ness.com>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
Subject: Re: Is EXT4 the right FS for > 16TB?
References: <alpine.DEB.2.00.1012190649060.5393@p34.internal.lan> <4D0E3435.30104@van-ness.com> <alpine.DEB.2.00.1012191151570.28865@p34.internal.lan> <4D0E3A63.606@sandeen.net> <alpine.DEB.2.00.1012191412520.27130@p34.internal.lan> <4D0E5D67.6060504@sandeen.net>
In-Reply-To: <4D0E5D67.6060504@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 02:30 PM, Eric Sandeen wrote:
> On 12/19/10 1:14 PM, Justin Piszcz wrote:
>>
>> On Sun, 19 Dec 2010, Eric Sandeen wrote:
>>
>>> On 12/19/10 10:53 AM, Justin Piszcz wrote:
>>>> Hi,
>>>>
>>>> Wow, there were no updates though after Eric's last comment..
>>>> Eric, have there been any improvements in the past 6 months?
>>>>
>>>> Or should one still steer clear from EXT4>  16TB?
>>> There is still no released e2fsprogs which supports>  16T for
>>> ext4, but testing of the not-released bits is welcomed...
>>> Ted says a 16T-capable version is coming soon.  There's still
>>> work to be done there, though.
>>>
>>> -Eric
>>>
>> Thanks Eric for confirming.
>>
>> With 7 x 3TB HDD its now possible to breach 16TB (16.38TB) in RAID-5 so I
>> suppose more people may start asking about this.
> Agreed, 16T is not that much these days.
>
> As Ric said, XFS will handle it without problem, though.
>
> -Eric
>

XFS as a base file system is in fact very popular with commercial storage 
vendors just because of the size limitations.

Also note that will really large drives, people are also really encouraged to 
use RAID-6 (larger drives take longer to rebuild, so you have more exposure to a 
double failure that would lose data in RAID-5)

Ric

