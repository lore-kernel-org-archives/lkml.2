Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179Ab1DDNbl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 09:31:41 -0400
Received: from ftp.sofha.de ([82.144.60.99]:41462 "EHLO ftp.sofha.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754120Ab1DDNbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 09:31:40 -0400
Message-ID: <4D99C83A.2080807@snafu.de>
Date: Mon, 04 Apr 2011 15:31:38 +0200
From: Oncaphillis <oncaphillis@snafu.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Xiaofan Chen <xiaofanc@gmail.com>
CC: Kernel development list <linux-kernel@vger.kernel.org>,
        libusb-devel@lists.sourceforge.net
Subject: Re: [Libusb-devel] Kernel bug message and missing data on libusb_interrupt_transfer
References: <4D99B60D.3030009@snafu.de> <BANLkTi=mU=v_6gH_5VCwZZmiX+UoqAVf+w@mail.gmail.com>
In-Reply-To: <BANLkTi=mU=v_6gH_5VCwZZmiX+UoqAVf+w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Thanks for the reply.

I'm in an environment where we are
reluctant to switch between versions. I had a hard time to
argue for 0.1.x to 1.0.x transition. We saw the same bug (or at least
kernel freezes in 0.1.x) I'll give 1.0.8 a try and report back.
  Using a git pull isn't an option for us for political reasons.

Thanks

O.


On 04/04/2011 03:06 PM, Xiaofan Chen wrote:
> On Mon, Apr 4, 2011 at 8:14 PM, Oncaphillis<oncaphillis@snafu.de>  wrote:
>> Hi,
>>
>>   We are experiencing sporadic kernel bug messages and total
>> kernel freezes on usb communication via libusb-1.0.6.
> First thing first, why not try the latest release version which
> is libusb-1.08?
>
> Or better yet, try the latest git from libusb-stuge branch
> which has quite some fixes post 1.08.
> http://git.libusb.org/?p=libusb-stuge.git;a=summary;js=1
>
>
>>   We are currently under kernel 2.6.30.10 but have seen
>> it also under older and newer kernel (I think the newest was
>> a 2.6.36.x).
>>
>
>

