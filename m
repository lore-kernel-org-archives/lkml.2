Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1DEHRg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 03:17:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55923 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab1DEHRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 03:17:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QKWO5aMfip0PS8DPU148gsslhwvB0R6c3WN2nKdZ0Ue58CsSpX0ZIp50+c0PlLjD4s
         p8rquJZKhkIvwRa2F+EO16kWHqTgzajBQR1nshcR1qSVmpI2OV4YutHn89/7YUR5Ebjd
         YmCd3QjItCsBSGBzWKCpWjEilFCW2Bqv+Pt/k=
MIME-Version: 1.0
In-Reply-To: <201103282143.58477.rjw@sisk.pl>
References: <201103270058.41632.rjw@sisk.pl>
	<AANLkTi=JW-xdzE3tCMohVZ1A=2pk2WHD0WrDPU4FNaXA@mail.gmail.com>
	<201103282143.58477.rjw@sisk.pl>
Date: Tue, 5 Apr 2011 16:17:33 +0900
Message-ID: <BANLkTi=oFuSRSCLZRGwZACioCxO0WSYsOQ@mail.gmail.com>
Subject: Re: [RFC][PATCH] PM / Platform: Remove __weak definitions of runtime
 PM callbacks
From: Magnus Damm <magnus.damm@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        linux-sh@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 4:43 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Monday, March 28, 2011, Magnus Damm wrote:
>> On Sun, Mar 27, 2011 at 8:58 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>> > From: Rafael J. Wysocki <rjw@sisk.pl>
>> >
>> > Remove the __weak definitions of platform bus type runtime PM
>> > callbacks, make platform_dev_pm_ops point to the generic routines
>> > as appropriate and allow architectures using platform_dev_pm_ops to
>> > replace the runtime PM callbacks in that structure with their own
>> > set.
>> >
>> > Convert architectures providing its own definitions of the platform
>> > runtime PM callbacks to use the new mechanism.
>> >
>> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
>>
>> Looking good, thanks Rafael. Tested on the sh7372 Mackerel board.
>>
>> Acked-by: Magnus Damm <damm@opensource.se>
>
> Thanks, I'll put it into my for-2.6.40 queue as soon as 2.6.39-rc1 is out.

Thanks. By the way, I think the symbols should be converted to static
as well. Do you prefer to make a V2 or shall we do that incrementally?

/ magnus
