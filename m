Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab2FSQxY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 12:53:24 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55364 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab2FSQxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 12:53:23 -0400
Message-ID: <4FE0AE7B.4040502@gmail.com>
Date: Tue, 19 Jun 2012 18:53:15 +0200
From: Paolo Pisati <p.pisati@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "T Krishnamoorthy, Balaji" <balajitk@ti.com>
CC: Ming Lei <ming.lei@canonical.com>, linux-mmc@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Chris Ball <cjb@laptop.org>, Venkatraman S <svenkatr@ti.com>
Subject: Re: MMC: commit dba3c29 ruins mmc card data on beagle-xm revB
References: <CACVXFVO-Wm1Qwporby1M=+yPz81AWHpZRBZSbr5tgT32b6sSEA@mail.gmail.com> <CANrkHUYd8Ww6De4MiZ8_oPfcnhvtsZXOySLRiWSBU4QUQ6beHw@mail.gmail.com> <CACVXFVP16UmHe-GGydrSMgGHwnkSvYhnY339=zr=BfCehvS8Kw@mail.gmail.com> <CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
In-Reply-To: <CANrkHUaxJGcv2bdUWTCB_oKct-iFCKCdb7OQPTUjS4MuKeCS2w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2012 05:28 PM, T Krishnamoorthy, Balaji wrote:
> On Mon, Jun 11, 2012 at 12:50 PM, Ming Lei <ming.lei@canonical.com> wrote:
>>
>> On Mon, Jun 11, 2012 at 2:21 PM, T Krishnamoorthy, Balaji
>> <balajitk@ti.com> wrote:
>>> Hi Ming Lei,
>>> Can you let me know if you noticed any write/timeout errors ?
>>
>> Nothing error logs found during writing.
> Hi,
> 
> Couldn't reproduce the issue with BeagleXM rev C, Might be a combination
> of rev and SD card. How often do you see mis-match in file content?

i just want to say that i'm affected by this too, and i can reproduce it
100%.

do you want me to run that patch or you already have enough data?
-- 
bye,
p.
