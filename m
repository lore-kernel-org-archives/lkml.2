Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759392Ab0LNPiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:38:54 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:61039 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab0LNPix convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:38:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=P9OgSZ9l27H3pX/0TgWWhG3QDXIThG4IPn9xKkMJQn2FmqruWdbqTBlaadCOwC1JRo
         32H5FKFu+XluNC/wVXaCW6jvtU/0/E/c+hKEMoAm88J9RvYBq+0tR87ZZwxKkCt/5NDS
         x4d82isIfasmZvOgu9sOR0gQkEhylF/2jubak=
MIME-Version: 1.0
In-Reply-To: <5312.1272375671@localhost>
References: <t2w8aa6b0651004241602i50449643lc05dcf834a80b344@mail.gmail.com>
	<5312.1272375671@localhost>
Date: Tue, 14 Dec 2010 17:38:51 +0200
X-Google-Sender-Auth: 8YSmj4zu0jX0pKd-ouHf1HkSeps
Message-ID: <AANLkTik6gRF+Z7Ay-DWr6WN3O4AfrNkZyEr4UieDDOFi@mail.gmail.com>
Subject: Re: Need advice on updating the Linux kernel map
From: Constantine Shulyupin <const@linuxdriver.co.il>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Valdis,

Thank you for your feedback.
I updated and continue to update the map of the Linux kernel -
http://www.makelinux.net/kernel_map

With your feedback I reworked connections and added
tracing/oprofile/perf to debug segment.

Indeeds, security and debugging is forced to be in user interface and
have no direct relations to peripherals. But other places are less
suable. I decided to put security and debugging in UI, because
security limits UI (as user) and debugging expands UI (as developer).

Thanks.

On Tue, Apr 27, 2010 at 4:41 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Sun, 25 Apr 2010 02:02:29 +0300, Constantine Shulyupin said:
>> I was wondering if you could help me. I've recently resumed work on
>> the map of the Linux kernel - http://www.makelinux.net/kernel_map in
>> order to make it more up-to-date and to improve it. Please let me know
>> how I can update the map, as it would help me a lot.
>
> A few quick comments:
>
> 1) Can we do better than an OSI 7-layer burrito? ;)  As it stands, doing it
> that way creates a lot of things that look like layering violations.  For
> instance, "Device Model" is up on "virtual", when it actually gets *used*
> several levels further down.  And you have a *lot* of vertical lines that
> cross a whole bunch of levels.  You would probably be served much better
> by letting each column be a lot wider, and maybe only 4 levels high (you
> can probably squish virtual/bridges/logical into one wider level).
>
> 1b) Much of the I/O column should be one wide section across the bottom of
> disk/network/user peripherals, and the 'system run' box should be in some
> other column(s).
>
> 2) Security and debugging seem to be forced in the "user peripherals" column
> for no real rational reason.
>
> 3) I see no mention of tracing/oprofile/perf.
>
> Hope that helps...
>



-- 
Constantine Shulyupin
Embedded Linux Expert
TI DaVinci Expert
Tel-Aviv Israel
http://www.LinuxDriver.co.il/
