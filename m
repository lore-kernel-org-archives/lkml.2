Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367Ab2BQP4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:56:35 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:34303 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751736Ab2BQP4e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <AE90C24D6B3A694183C094C60CF0A2F6026B6E75@saturn3.aculab.com>
References: <1329492603-3972-1-git-send-email-lfelipe@profusion.mobi>
	<AE90C24D6B3A694183C094C60CF0A2F6026B6E75@saturn3.aculab.com>
Date: Fri, 17 Feb 2012 13:56:33 -0200
Message-ID: <CAHPwkG0yFX7Cac0NVc8obZ8N-07gck7bkTTCZvpCzY27wj1nzg@mail.gmail.com>
Subject: Re: [PATCH] Cleaning up code formatting errors in net/wireless
 pointed out by checkpatch.
From: Luis Felipe Strano Moraes <lfelipe@profusion.mobi>
To: David Laight <David.Laight@aculab.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net, davem@davemloft.net,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 February 2012 13:47, David Laight <David.Laight@aculab.com> wrote:
>
>> These are mostly minor changes and they are being sent as one
>> patch only in order to cause the smallest amount of disruption.
>
> A lot of these changes don't seem to match what I thought the
> linux kernel code style is.
>
> eg:
>>  void cfg80211_bss_age(struct cfg80211_registered_device *dev,
>> -                      unsigned long age_secs);
>> +                   unsigned long age_secs);
> Args no longer lined up.

It's ligned up here, perhaps mine (or yours) mail client is screwing
something up. This one was basically using tabs where they were
supposed to be.

>
>> -             pos = (u8 *) & hdr->addr4;
>> +             pos = (u8 *) &hdr->addr4;
> no space after cast?

There is a space there. The problem pointed by checkpatch was the
space between '&' and hdr.

>
>> -     p1 = (u8*)(ht_capa);
>> +     p1 = (u8 *)(ht_capa);
> Still extra ().
>
> I'm also not sure (personally) this sort of churn is useful.

As mentioned, those are mostly minor changes based on checkpatch's
output. Cleaning up only things that were specifically marked as
errors (so the extra parentheses there were not reported).

I don't think having lots of this kind of churn useful, thats why I
sent one patch only for the entire directory trying to clean up as
much as possible. There are some errors that I didn't clean up, but
they are mostly where an option was made on the source code to keep
code in a more readable way.

--lf


>
>        David
>
>



-- 
Luís Felipe Strano Moraes
Project Manager @ ProFUSION embedded systems
http://profusion.mobi
