Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725Ab0HPHLn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:11:43 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:60905 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751339Ab0HPHLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:11:42 -0400
Message-ID: <4C68E4A5.3050800@example.com>
Date: Mon, 16 Aug 2010 09:11:33 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <20100814210044.GA29375@merkur.ravnborg.org> <4C671455.4040908@example.com> <201008160858.42947.arnd@arndb.de>
In-Reply-To: <201008160858.42947.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16476419238117142788
X-Ovh-Remote: 83.24.80.89 (dmy89.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.08.2010 08:58, Arnd Bergmann wrote:
> On Sunday 15 August 2010 00:10:29 Piotr Hosowicz wrote:
>> Yes, this was it. I made git pull and git revert and now I am up and
>> kicking. But how will I manage with it not by git but by kernel org
>> provioded files? And even if I used git all the time will I have to
>> revert it each time and what's the worse I will become more and more out
>> of sync because people will write their code as if I did not revert.
>
> Just fix your driver code to no longer rely on the big kernel lock

Now I know how to do it.

> and then make it use the unlocked_ioctl operation.

This I do not know. Can You help me?

Regards,

Piotr Hosowicz

-- 
"[Oleksy] dotkn±³ naszych domów, naszych ¿on, naszych dzieci,
naszych psów, naszych ¦WINEK MORSKICH, on po prostu wkroczy³
swoim g³upim gadaniem w sferê prywatn±, która musi byæ chro-
niona dla dobra ka¿dego z nas" - powiedzia³ Kwa¶niewski.
NP: Patrick O'Hearn - Night Becomes Her
NB: 2.6.35-git16
