Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab0IYVVJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 17:21:09 -0400
Received: from tuxonice.net ([74.207.252.127]:46644 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0IYVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 17:21:08 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4C9E67C1.5030202@tuxonice.net>
Date: Sun, 26 Sep 2010 07:21:05 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: Martin Steigerwald <Martin@lichtvoll.de>
CC: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: [linux-pm] Nigel's current for-rafael queue
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> (sfid-20100925_095715_038909_A9814B83) <201009251704.50186.Martin@lichtvoll.de>
In-Reply-To: <201009251704.50186.Martin@lichtvoll.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again.

(I know from your more recent email that you already know the answer to 
this, but others might be interested so I'll reply anyway).

On 26/09/10 01:04, Martin Steigerwald wrote:
> Am Samstag 25 September 2010 schrieb Nigel Cunningham:
>> Hi Rafael.
>
> Hi Nigel,
>
>> Please find attached a slightly updated version of the patchset I sent
>> a few months ago. The main change is that I've prepended and additional
>> patch which lets the user see the speed at which the image is being
>> read and written. This is accomplished by recording the MB/s in a
>> single byte in the image header, and using a couple of __nosavedata
>> variables to get the data back through the atomic restore. I realise
>> the char limits us to 255MB/s at the moment. In future patches, I
>> intend to address this by storing the data in a 'proper' image header
>> (it's a real problem - TuxOnIce reads and writes on the same set up at
>> speeds around 250MB/s).
>
> I like to help by testing these. Is it sufficient to check out your latest
> tuxonice tree, checkout branch for-rafael and switch the hibernate script
> to TryMethod disk.conf?

Yes, that should be sufficient. You do need to be aware (as I said in 
the other reply) that I'm treating this branch like a temporary branch, 
so it's getting rebased and having little modifications made to it. 
Pulling will therefore sometimes require the use of the force option.

Regards,

Nigel
