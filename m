Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351Ab0IYWdz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 18:33:55 -0400
Received: from tuxonice.net ([74.207.252.127]:38640 "EHLO mail.tuxonice.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab0IYWdy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 18:33:54 -0400
X-Bogosity: Ham, spamicity=0.000240
Message-ID: <4C9E78CF.4090201@tuxonice.net>
Date: Sun, 26 Sep 2010 08:33:51 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.10pre) Gecko/20100903 Shredder/3.1.4pre
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux PM <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        TuxOnIce-devel <tuxonice-devel@tuxonice.net>
Subject: Re: Nigel's current for-rafael queue
References: <1285388224-10012-1-git-send-email-nigel@tuxonice.net> <201009260019.37438.rjw@sisk.pl>
In-Reply-To: <201009260019.37438.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 26/09/10 08:19, Rafael J. Wysocki wrote:
> On Saturday, September 25, 2010, Nigel Cunningham wrote:
>> Hi Rafael.
>
> Hi Nigel,
>
>> Please find attached a slightly updated version of the patchset I sent
>> a few months ago. The main change is that I've prepended and additional
>> patch which lets the user see the speed at which the image is being
>> read and written. This is accomplished by recording the MB/s in a single
>> byte in the image header, and using a couple of __nosavedata variables
>> to get the data back through the atomic restore. I realise the char limits
>> us to 255MB/s at the moment. In future patches, I intend to address this
>> by storing the data in a 'proper' image header (it's a real problem -
>> TuxOnIce reads and writes on the same set up at speeds around 250MB/s).
>>
>> Results on my Dell XPS M1530, which has an SSD hard drive are:
>>
>> With just patch 1 applied:
>> Attempt 1: Write 74MB/s; Read 52MB/s
>> Attempt 2: Write 68MB/s; Read 52MB/s
>> Attempt 3: Write 73MB/s; Read 53MB/s
>>
>> With the whole sequence:
>> Attempt 1: Write 181MB/s; Read 52MB/s
>> Attempt 2: Write 156MB/s; Read 53MB/s
>> Attempt 3: Write 160MB/s; Read 52MB/s
>
> Thanks for the patches, they look like a real improvement to me.
>
> I only had a couple of minor comments, sent separately in replies to individual
> patches.  I'd like to push this series for 2.6.37, if the comments are
> addressed timely.

Okay. I'll update the patches. You can pull from

git://git.kernel.org/pub/scm/linux/kernel/git/nigelc/tuxonice-head.git#for-rafael

if you want.

I'll apply your suggestions/comments to the versions there. I'll also 
checkout what's going on with Martin's machine and hopefully apply 
whatever fix is needed there too. Will keep you up to date with any changes.

Regards,

Nigel
