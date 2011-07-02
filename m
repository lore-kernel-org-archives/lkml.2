Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1GBO2s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jul 2011 10:28:48 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61918 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385Ab1GBO2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jul 2011 10:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1106281238210.7935@asgard.lang.hm>
References: <BANLkTin_Yo+wnwWyMFoG3Nv5SSzJj8J1_w@mail.gmail.com>
	<alpine.DEB.2.02.1106281238210.7935@asgard.lang.hm>
Date: Sat, 2 Jul 2011 10:28:44 -0400
Message-ID: <BANLkTi=tFc2uoGMNFAAFqpeka_otC6CsOQ@mail.gmail.com>
Subject: Re: Question on syslogd and syslog
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: david@lang.hm
Cc: linux-kernel-mail <linux-kernel@vger.kernel.org>,
        linux-newbie@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the replies. My question is more on how to extend
facilities, rather on how to filter the messages. It seems there is a
code in the toolchain syslog.h where the array representing the
facilities needs to be extended. Please correct me if I am wrong.

Sri.

On Tue, Jun 28, 2011 at 3:41 PM,  <david@lang.hm> wrote:
> you would be creating a completely different over-the-wire protocol for your
> syslog messages.
>
> however, note that newer syslog daemons (syslog-ng and rsyslog for example)
> allow you to do filtering on just about anything in the message, not just
> the facility and severity.
>
> David Lang
>
> On Tue, 28 Jun 2011, Sri Ram Vemulpali wrote:
>
>> Date: Tue, 28 Jun 2011 14:11:59 -0400
>> From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
>> To: linux-kernel-mail <linux-kernel@vger.kernel.org>,
>>    linux-newbie@vger.kernel.org
>> Subject: Question on syslogd and syslog
>>
>> Hello All,
>>
>>   I am looking to modify number of facilities available in syslog so
>> that for my application I can have much more array of them at disposal
>> of my need. So currently only LOG_LOCAL0 - LOG_LOCAL7 are defined for
>> user, what if I want to extend them, is there a way I can extend them.
>> Or should I go ahead and modify the source code of syslog. Can any
>> please point me in right direction and where can I get syslogd and
>> syslog source code. Thanks in advance.
>>
>>
>



-- 
Regards,
Sri.
