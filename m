Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab2FWS36 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 14:29:58 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61635 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2FWS35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 14:29:57 -0400
MIME-Version: 1.0
In-Reply-To: <20120620230839.GA17883@kroah.com>
References: <1340132742-18849-1-git-send-email-devendra.aaru@gmail.com>
	<20120620230839.GA17883@kroah.com>
Date: Sat, 23 Jun 2012 23:59:57 +0530
Message-ID: <CAHdPZaNbMA+0FsiArG2WdO-izrV44hQZo6ibTwZcHgeftGNPpQ@mail.gmail.com>
Subject: Re: [PATCH V2 1/3] staging/rtl8192u: fix coding style problems
From: "devendra.aaru" <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Justin P. Mattock" <justinmattock@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2012 at 4:38 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jun 20, 2012 at 12:35:42AM +0530, Devendra Naga wrote:
>> -     bit=(read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT) );
>> +     bit = (read_nic_byte_E(dev, EPROM_CMD) & (1<<EPROM_R_SHIFT));
>>       udelay(EPROM_DELAY);
>>
>> -     if(bit) return 1;
>> -     return 0;
>> +     return !!bit;
>
> Oh come on, really?  !! is more "clear" here?
>
It looks ok to me,
> No, please be painfully obvious, that's the only way to write kernel
> code.  Not like this.
>
Ok, so no !!'s ? and just that if (bit) thingy?

> greg k-h
