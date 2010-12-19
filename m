Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932548Ab0LSXVs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 18:21:48 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:44938 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab0LSXVr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 18:21:47 -0500
MIME-Version: 1.0
In-Reply-To: <201012192202.34894.rjw@sisk.pl>
References: <ZRNlsjykcOD.A.b-F.20fDNB@chimera>
	<xqq2Z3iR9HJ.A.T2G.A2fDNB@chimera>
	<AANLkTi=8Wdv4bwcFb+FS6R+stnrxHo8tB8iCHoqNYRYu@mail.gmail.com>
	<201012192202.34894.rjw@sisk.pl>
Date: Sun, 19 Dec 2010 15:21:45 -0800
Message-ID: <AANLkTi==H5EE0-1JPkkLzSAF6NUBw0N6vyHqOr9OwH8T@mail.gmail.com>
Subject: Re: [Bug #20462] 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
From: Jesse Gross <jesse@nicira.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Nikola Ciprich <extmaillist@linuxbox.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 1:02 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Sunday, December 19, 2010, Jesse Gross wrote:
>> On Sun, Dec 19, 2010 at 4:50 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > This message has been generated automatically as a part of a report
>> > of regressions introduced between 2.6.35 and 2.6.36.
>> >
>> > The following bug entry is on the current list of known regressions
>> > introduced between 2.6.35 and 2.6.36.  Please verify if it still should
>> > be listed and let the tracking team know (either way).
>> >
>> >
>> > Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=20462
>> > Subject         : 2.6.36-rc7-git2 - panic/GPF: e1000e/vlans?
>> > Submitter       : Nikola Ciprich <extmaillist@linuxbox.cz>
>> > Date            : 2010-10-15 7:10 (66 days old)
>> > Message-ID      : <20101015071008.GA8714@pcnci.linuxbox.cz>
>> > References      : http://marc.info/?l=linux-kernel&m=128712984831303&w=2
>> > Handled-By      : Jesse Gross <jesse@nicira.com>
>> > Patch           : http://www.spinics.net/lists/netdev/msg146227.html
>>
>> Fixed in 2.6.36.2.
>
> Thanks, closing.
>
> Do you know the commit that fixed it?

1b7cd15c8c89f5c26dc525d985e45c9bd9265fe2

Thanks.
