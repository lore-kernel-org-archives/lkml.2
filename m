Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab1CSQiL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 12:38:11 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:59981 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab1CSQiJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 12:38:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nr85S1ZMPN1ER3PpK67iW2uP0YsdlddeP7iGw0ovf1YnLbpI0gVMNkOb5QM677d5Z7
         QnoWM4fm2ZgxqDwttO/KeMwaFOrMrfHNwIjlEorZVLGbsBrVQyzuZWxglEKRulthIuhw
         mebW60h5xSRkKzFJQkauOh+b1eiovLFhfp+rc=
MIME-Version: 1.0
In-Reply-To: <4D84D956.8090407@example.com>
References: <4D84A46B.1000407@example.com>
	<AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
	<1300547930.2831.27.camel@edumazet-laptop>
	<201103191631.07952.oliver@neukum.org>
	<1300548821.2831.28.camel@edumazet-laptop>
	<1300549151.2831.32.camel@edumazet-laptop>
	<4D84D098.1050802@example.com>
	<1300550653.2831.34.camel@edumazet-laptop>
	<4D84D956.8090407@example.com>
Date: Sat, 19 Mar 2011 18:38:07 +0200
Message-ID: <AANLkTim9m2A6MXBrx2QHLYNTph9mW9+BUyQpwL5QpjtB@mail.gmail.com>
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
From: Anca Emanuel <anca.emanuel@gmail.com>
To: piotr@hosowicz.com
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Oliver Neukum <oliver@neukum.org>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 19, 2011 at 6:27 PM, Piotr Hosowicz <piotr@hosowicz.com> wrote:
> On 19.03.2011 17:04, Eric Dumazet wrote:
>>
>> Le samedi 19 mars 2011 à 16:49 +0100, Piotr Hosowicz a écrit :
>>
>>> I do not understand. I reverted the commit you mentioned and am building
>>> now. Will it suffice?
>>>
>>
>> Either you
>>
>> 1) Revert the commit
>
> OK. This is what I've done and everything is OK, net works as usual. But
> what should I do next? Will the revert be done on the GIT server? And when?
> I try not to clone to much and wastefuly. And am new to GIT so sorry for the
> question.

Next: Test Eric's patch, and send and email with Tested-by tag.
