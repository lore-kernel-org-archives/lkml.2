Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab1FDOgU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 10:36:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32904 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab1FDOgS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 10:36:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=A9OP6kOjXgMv4NuVihmdRr3VF4ufcnZutcSIGosQhEQ0ieYdxXrUtTELdRv8iFxC5x
         YLcS6AVbfnoRf1XdJCGg4ZxtBA/tcpYKLXIEiWSLOxqlsIsHCvkKlg4FEn2j2ov1/j0J
         00meTxqnSsmEIsqqwIKTxVZQE3Th/6mOa+5Mw=
MIME-Version: 1.0
In-Reply-To: <20110604130413.GA3929@tuxdriver.com>
References: <20110603195254.GF2509@tuxdriver.com>
	<BANLkTimoeVDQK+zu=U+nSM_kj0a3-hh_Jg@mail.gmail.com>
	<20110604130413.GA3929@tuxdriver.com>
Date: Sat, 4 Jun 2011 16:36:17 +0200
Message-ID: <BANLkTimF3Jr4Kp7rDo1dvdBxVPepr__OZw@mail.gmail.com>
Subject: Re: pull request: wireless-2.6 2011-06-03
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 4 czerwca 2011 15:04 użytkownik John W. Linville
<linville@tuxdriver.com> napisał:
> On Fri, Jun 03, 2011 at 11:24:49PM +0200, Rafał Miłecki wrote:
>> On Jun 3, 2011 10:03 PM, "John W. Linville" <linville@tuxdriver.com> wrote:
>> >
>> > Dave,
>> >
>> > Here is a batch of fixes intended for 3.0 -- I guess I'll need to
>> > rename my tree eventually... :-)
>> >
>> > Included are a libertas fix to ensure proper sequence number assignment
>> > on transmitted frames, an ath9k fix that propogates an earlier fix to a
>> > few more places,  a fix for a cfg80211 regression caused by some mesh
>> > code changes, a locking fix for the bluetooth l2cap code, a zd1211rw
>> > regression fix, a collection of small fixes for wl12xx, an iwl4965
>> > fix for a bad temperature check, an a device ID-related fix for iwlagn.
>> >
>> > Please let me know if there are problems!
>>
>> John, you didn't.take my fix for regression in ssb. I really want this for
>> 3.0.quickly, as few ppl already had problems with machine locking on boot.
>
> Yours isn't the only fix, and I had quite a few queued already.  Patience.

OK, I was just afraid you missed this one :) Sorry if I meant rude.

-- 
Rafał
