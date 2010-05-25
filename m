Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab0EYP6f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 11:58:35 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39526 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756255Ab0EYP6c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 11:58:32 -0400
MIME-Version: 1.0
X-Originating-IP: [172.24.11.26]
In-Reply-To: <20100524235544.GB7204@redhat.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
	 <1274294304-30606-3-git-send-email-wad@chromium.org>
	 <20100524115737.GY3991@agk-dp.fab.redhat.com>
	 <AANLkTik8F43_4SRkH7XpfX5CTQ-xQ_8f3_yJTjDqSulU@mail.gmail.com>
	 <20100524150729.GZ3991@agk-dp.fab.redhat.com>
	 <AANLkTinlgQ5Br4vyjgvNKtHD4F3mZKwoz3siYCQyReAl@mail.gmail.com>
	 <20100524233552.GA7204@redhat.com> <20100524235544.GB7204@redhat.com>
Date: Tue, 25 May 2010 10:58:29 -0500
X-Google-Sender-Auth: wSw88518KfKYK7OV81jW04uRnZA
Message-ID: <AANLkTin_z74cq3HSWHYLxYzSLDI_HeI9fGAdtJdbvcb_@mail.gmail.com>
Subject: Re: [PATCH v3 3/3] dm: lookup devices by path with name_to_dev_t
From: Will Drewry <wad@chromium.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 6:55 PM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Mon, May 24 2010 at  7:35pm -0400,
> Mike Snitzer <snitzer@redhat.com> wrote:
>
>> On Mon, May 24 2010 at 12:35pm -0400,
>> Will Drewry <wad@chromium.org> wrote:
>>
>> > On Mon, May 24, 2010 at 10:07 AM, Alasdair G Kergon <agk@redhat.com> wrote:
>> > > On Mon, May 24, 2010 at 09:44:07AM -0500, Will Drewry wrote:
>> > >> fwiw, the only reason for the copy was because |path| is a
>> > >> const in the function but not when passed to name_to_dev_t.
>> > >> I wasn't sure what the preferred practice was so I just duped
>> > >> the data needed.
>> > >
>> > > Well check that it is treated as 'const' and send a separate patch to
>> > > the maintainer to add const, perhaps?  If it isn't const (why would
>> > > that be?), then yes we'd need to copy it.
>> >
>> > I'll cross-check the code again and send a patch out if it looks like
>> > it is const-safe.
>>
>> Also, it would see that name_to_dev_t is EXPORT_SYMBOL?
>
> Bleh, I typed that way too quick:
> Also, it would seem that name_to_dev_t is _not_ EXPORT_SYMBOL?


I've just mailed out a patch for each issue:
- const char *: https://patchwork.kernel.org/patch/102228/
- export_symbol: https://patchwork.kernel.org/patch/102229/

Cheers!
will
