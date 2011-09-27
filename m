Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196Ab1I0RcM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 13:32:12 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27283 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab1I0RcK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 13:32:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=cN/bBq49PcMrvRHmG7I+Y4+iFp4NAdRgxiqX6q2NNSwRedENrZFAcbKFDzJig32wv
	JS6YZ6At3qpij4r9onu/A==
MIME-Version: 1.0
In-Reply-To: <CAHp75VdJ+ZeVLPhb5R1_29k7cLWb9hFaMy+TS7HqioLiRm+8gQ@mail.gmail.com>
References: <20110919232602.ac450450.akpm00@gmail.com>
	<fa146966b0ce1e7f04d59eb27cc0e968f51b22de.1316774801.git.andriy.shevchenko@linux.intel.com>
	<20110923131819.fdaed4ab.akpm@google.com>
	<CAHp75VdJ+ZeVLPhb5R1_29k7cLWb9hFaMy+TS7HqioLiRm+8gQ@mail.gmail.com>
Date: Tue, 27 Sep 2011 10:32:07 -0700
Message-ID: <CAKiorj5MJ8_ZH-J-7GjNQLoPNTshFdrrHfjptgpgi_4mchHJYw@mail.gmail.com>
Subject: Re: [PATCH 1/2] kernel.h: rename pack_hex_byte to hex_pack_byte
From: Andrew Morton <akpm@google.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 3:51 AM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Fri, Sep 23, 2011 at 11:18 PM, Andrew Morton <akpm@google.com> wrote:
>> err, no thanks.  That's just going to hit everyone with great
>> screenfuls of compile warnings while waiting for someone else to fix
>> them up.
>
> Okay, what about renaming pack_hex_byte to hex_byte_pack and
> introducing temporary macro for backward compatibility?

It's better to convert all the in-kernel call sites at the same time
as adding the
__deprecated tag to the old function.
