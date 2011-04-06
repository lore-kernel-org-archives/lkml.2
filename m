Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757020Ab1DFXU2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 19:20:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:64735 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab1DFXUS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 19:20:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vcSj/9jvZuyQ3E967WPXP8FbhMIhlU7ea2BX21ZlqShfBcFL/SaqJGBcH3DtJacSmC
         /CDRgl33CmRGljTFLawd4qiX3NWdzdNUfYPrbJ8GVqq3wGYBVpZgYiBFIIMXTtqoLijC
         T5glG/qQRfiQXDr85iYrygbxwJM86Zt6GHHI8=
MIME-Version: 1.0
In-Reply-To: <1302124737.27258.7.camel@dev.znau.edu.ua>
References: <1302033463-1846-1-git-send-email-zajec5@gmail.com>
	<op.vtisojsk3ri7v4@arend-laptop>
	<BANLkTinubrmryu=Bco5_AVcj_arn7SWZxw@mail.gmail.com>
	<op.vti9ote53ri7v4@arend-laptop>
	<BANLkTin-u=U_-cUH9oCco0LjEBuQmh4wag@mail.gmail.com>
	<BANLkTi=x89+52cMeutOB7J--QQta+mX_wg@mail.gmail.com>
	<1302123428.20093.6.camel@maggie>
	<BANLkTimGSoYzp0Z4vyCS_H5PDKhgjYuLBA@mail.gmail.com>
	<1302124112.20093.11.camel@maggie>
	<BANLkTik76dwwnmmPzXL9Kkk7fdt01QPzZA@mail.gmail.com>
	<1302124737.27258.7.camel@dev.znau.edu.ua>
Date: Thu, 7 Apr 2011 01:20:17 +0200
Message-ID: <BANLkTi=4-LgrkjG96+Ar3SjMOsKh-dMuLg@mail.gmail.com>
Subject: Re: [RFC][PATCH] bcmai: introduce AI driver
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: George Kashperko <george@znau.edu.ua>
Cc: Arend van Spriel <arend@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <rmk@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linuxdriverproject <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 6 kwietnia 2011 23:18 użytkownik George Kashperko
<george@znau.edu.ua> napisał:
>> We have 2 windows. I didn't try this, but let's assume they have no
>> limitations. We can use first window for one driver only, second
>> driver for second driver only. That gives us 2 drivers simultaneously
>> working drivers. No driver need to reset core really often (and not
>> inside interrupt context) so we will switch driver's window to agent
>> (from core) only at init/reset.
>>
>> The question is what amount of driver we will need to support at the same time.
>>
>
> I guess (correct me please, Broadcom guys if I'm wrong) there are two
> functions two-head w11 pci host and therefore 4 sliding windows, 2 per
> each function.

I don't understand you. Can you use more friendly language? functions?
2head? w11?

-- 
Rafał
