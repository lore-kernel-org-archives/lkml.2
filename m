Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751672Ab1IDQZ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 12:25:59 -0400
Received: from 14.mo3.mail-out.ovh.net ([188.165.43.98]:40574 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751320Ab1IDQZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 12:25:51 -0400
X-Greylist: delayed 900 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Sep 2011 12:25:51 EDT
Message-ID: <4E63A0A8.4000103@example.com>
Date: Sun, 04 Sep 2011 18:00:40 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.21) Gecko/20110831 Thunderbird/3.1.13
MIME-Version: 1.0
To: Florian Mickler <florian@mickler.org>
CC: LKML <linux-kernel@vger.kernel.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: Some regression since rc3
References: <4E5A651A.6020005@example.com> <20110904174627.7506c6ff@schatten.dmk.lab>
In-Reply-To: <20110904174627.7506c6ff@schatten.dmk.lab>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 11576784317554323721
X-Ovh-Remote: 178.36.159.122 (178-36-159-122.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -200
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfedvkedrtdduucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmneculddquddttddm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04.09.2011 17:46, Florian Mickler wrote:
> On Sun, 28 Aug 2011 17:56:10 +0200
> Piotr Hosowicz<piotr@hosowicz.com>  wrote:
>
>> Hi,
>>
>> I almost cannot work. I tried todays rc3-git3 and I see that icedove
>> mailer keeps growing almost instantly to 100% cpu. I tried rc3-git3 but
>> to no avail. I am booted on plain rc3 now and I can work, but not
>> perfect still as before.
>>
>> Regards,
>>
>> Piotr Hosowicz
>>
>
> Not enough information. It would be interesting to see what icedove is
> doing. GDB or strace might give a hint.
>
> If this is still a problem with current git and it is reproducible, can
> you bisect which change caused this?

Debian made me mad at last so I installed Ubuntu. The practical problem 
is gone for me. Sorry for the noise.

-- 
- Jaka jest najwiêksza anomalia fizjologiczno-polityczna?
- Cz³onek wysuniêty z ramienia na czo³o.
NP: Caligula's Horse - Equally Flawed
NB: 3.1.0-rc3
