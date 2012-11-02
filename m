Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761486Ab2KBXAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 19:00:23 -0400
Received: from spam1.webland.se ([91.207.112.90]:56762 "EHLO spam1.webland.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab2KBXAW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 19:00:22 -0400
X-Greylist: delayed 639 seconds by postgrey-1.27 at vger.kernel.org; Fri, 02 Nov 2012 19:00:22 EDT
From: Arvid Brodin <Arvid.Brodin@xdin.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Arvid Brodin <Arvid.Brodin@xdin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        "David Rientjes" <rientjes@google.com>
Subject: Re: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Thread-Topic: fs/proc/base.c: text md5sums; tgid vs tid; and INF vs ONE?
Thread-Index: AQHNtuHiwCMp4/hqTEiwDalQNzY3mQ==
Date: Fri, 2 Nov 2012 22:49:40 +0000
Message-ID: <50944E03.80802@xdin.com>
References: <50904066.4060404@xdin.com> <87ip9refzk.fsf@xmission.com>
 <5092DBA4.3070707@xdin.com>
In-Reply-To: <5092DBA4.3070707@xdin.com>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20120410
 Thunderbird/8.0
Content-Type: text/plain; charset="utf-8"
Content-ID: <70612FBF8A3D5C428E9A15C20D877FC3@redbull.xdin.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id qA2N0RIo032299

On 2012-11-01 21:29, Arvid Brodin wrote:
> On 2012-10-30 23:45, Eric W. Biederman wrote:
>> I recommend you checkout the code in security/ima/ looks like it can
>> already do what you are trying to do.
> 
> Ah. I did actually check this out a year and a half ago or something like that. Seems like
> it has gotten a bit more capable since then with the new patches (immutable executables
> etc)! I'll take a look at it again to see if it might fit our needs. Thanks!
> 

It looks like IMA only checks files when they are accessed; I cannot find any mechanism
for checking code that is already executing. So it won't help us, unfortunately.

-- 
Arvid Brodin | Consultant (Linux)
XDIN AB | KnarrarnÃ¤sgatan 7 | SE-164 40 Kista | Sweden | xdin.comÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
