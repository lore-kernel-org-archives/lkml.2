Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab0LAH7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 02:59:38 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45147 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993Ab0LAH7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 02:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=w2CBCV+jzDi8dxSDD0/+3OqpoVTALoccc+m8C5awc4ZHDoL1RTql4q4Px0TsRu+WWg
         SNAttdB0fpJWitiYl4slhTTWvZgf+uEuLqGWmqhYZxz2WafyRxCkF8f3Cv8fGgqQPl4+
         Ai+KDL1bqhQX6y8pX0BUaT3UI8e85iZxRri/A=
MIME-Version: 1.0
In-Reply-To: <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
References: <5febb0e1fba0ec2bb77f6ade8b251ba0edf4614c.1290988277.git.joe@perches.com>
 <AANLkTinc251WbwuLqFbOZ5ipNGZW7=wub3DoWwy42=+e@mail.gmail.com>
 <20101129060732.5130.qmail@stuge.se> <4CF42C17.2070500@openwrt.org>
 <1291081185.16349.133.camel@Joe-Laptop> <4CF464D6.2020507@openwrt.org>
 <1291148375.18026.342.camel@Joe-Laptop> <AANLkTik2qtGUgkZYSjcEH9jHHsevKnxOvz4s6On94U9o@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Nov 2010 23:59:15 -0800
Message-ID: <AANLkTinuVWuiVpKrz_oEAFKt6Hgxu4kU13iKthj8E0m1@mail.gmail.com>
Subject: Re: [ath9k-devel] [PATCH wireless-next] ath: Rename ath_print to ath_debug
To: Joe Perches <joe@perches.com>
Cc: Felix Fietkau <nbd@openwrt.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath9k-devel@venema.h4ckr.net, peter@stuge.se,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 11:56 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> On Tue, Nov 30, 2010 at 12:19 PM, Joe Perches <joe@perches.com> wrote:
>> On Tue, 2010-11-30 at 03:43 +0100, Felix Fietkau wrote:
>>> On 2010-11-30 2:39 AM, Joe Perches wrote:
>>> > I gauge my willingness to spend time on subsystems on
>>> > the maintainers willingness to merge things that improve
>>> > readability and correctness.
>>> I'm not trying to discourage you from spending time on improving this
>>> code, just doubting the usefulness of such simple function renames.
>>
>> Poor function naming is just that.
>> It reduces readability and the uses are counter expectation.
>
> The name is perfect, we use it to print anything, even non-debugging stuff.

If you are writing trivial patches please be ready to accept trivial
NACKs for them as well. IMHO its best if the large diffstat trivial
patches had more purpose than just scratch a small tiny itch.

  Luis
