Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab0EXQgE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 12:36:04 -0400
Received: from smtp-out.google.com ([74.125.121.35]:21079 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757244Ab0EXQgB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 12:36:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:sender:in-reply-to:references:date:
	x-google-sender-auth:message-id:subject:from:to:content-type:
	content-transfer-encoding:x-system-of-record;
	b=ddTYNbrlSdPl4M3XaueENwyuI3bAmKtsF0hK0Ba7qmFGw2rP7J1yQYTA/IqYS2qui
	9hnSTqTyyba6mH63hihZg==
MIME-Version: 1.0
In-Reply-To: <20100524150729.GZ3991@agk-dp.fab.redhat.com>
References: <1274294304-30606-1-git-send-email-wad@chromium.org>
	<1274294304-30606-3-git-send-email-wad@chromium.org>
	<20100524115737.GY3991@agk-dp.fab.redhat.com>
	<AANLkTik8F43_4SRkH7XpfX5CTQ-xQ_8f3_yJTjDqSulU@mail.gmail.com>
	<20100524150729.GZ3991@agk-dp.fab.redhat.com>
Date: Mon, 24 May 2010 11:35:57 -0500
X-Google-Sender-Auth: 2rcLpPQrO8bvEgLiH1Pg1VKH4IU
Message-ID: <AANLkTinlgQ5Br4vyjgvNKtHD4F3mZKwoz3siYCQyReAl@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v3 3/3] dm: lookup devices by path with 
	name_to_dev_t
From: Will Drewry <wad@chromium.org>
To: Will Drewry <wad@chromium.org>, dm-devel@redhat.com,
       linux-kernel@vger.kernel.org, snitzer@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 10:07 AM, Alasdair G Kergon <agk@redhat.com> wrote:
> On Mon, May 24, 2010 at 09:44:07AM -0500, Will Drewry wrote:
>> fwiw, the only reason for the copy was because |path| is a
>> const in the function but not when passed to name_to_dev_t.
>> I wasn't sure what the preferred practice was so I just duped
>> the data needed.
>
> Well check that it is treated as 'const' and send a separate patch to
> the maintainer to add const, perhaps?  If it isn't const (why would
> that be?), then yes we'd need to copy it.

I'll cross-check the code again and send a patch out if it looks like
it is const-safe.

thanks,
will
