Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760129Ab2KAU32 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:29:28 -0400
Received: from spam1.webland.se ([91.207.112.90]:52044 "EHLO spam1.webland.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759151Ab2KAU31 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:29:27 -0400
X-Greylist: delayed 436 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Nov 2012 16:29:26 EDT
From: Arvid Brodin <Arvid.Brodin@xdin.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Cyrill Gorcunov" <gorcunov@openvz.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Thread-Topic: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Thread-Index: AQHNtuHiwCMp4/hqTEiwDalQNzY3mZfSctrIgALtyAA=
Date: Thu, 1 Nov 2012 20:29:25 +0000
Message-ID: <5092DBA4.3070707@xdin.com>
References: <50904066.4060404@xdin.com> <87ip9refzk.fsf@xmission.com>
In-Reply-To: <87ip9refzk.fsf@xmission.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120410
 Thunderbird/8.0
Content-Type: text/plain; charset="utf-8"
Content-ID: <8A8ED58D61E7A047858748414E206C5D@redbull.xdin.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA1KTWLL026768

On 2012-10-30 23:45, Eric W. Biederman wrote:
> Arvid Brodin <Arvid.Brodin@xdin.com> writes:
>> Hi,
>> []

Thanks for the info!

>> * Any other comments about the code?
> 
> There are known successful attacks against md5 so using md5 for
> something new and security related is a bad idea.
> 
> Userspace can just as easily compute a security hash itself you don't
> need kernel support.

How would I do this on running code? Does the kernel export the process memory somewhere
so that I can pipe it to md5sum?


> I recommend you checkout the code in security/ima/ looks like it can
> already do what you are trying to do.

Ah. I did actually check this out a year and a half ago or something like that. Seems like
it has gotten a bit more capable since then with the new patches (immutable executables
etc)! I'll take a look at it again to see if it might fit our needs. Thanks!

> 
> Eric


-- 
Arvid Brodin | Consultant (Linux)
XDIN AB | KnarrarnÃ¤sgatan 7 | SE-164 40 Kista | Sweden | xdin.comÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
