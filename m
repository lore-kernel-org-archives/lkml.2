Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577Ab1ITGKr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 02:10:47 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54649 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab1ITGKp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 02:10:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110919153810.ba0be83a.akpm@google.com>
References: <1316177430-13167-1-git-send-email-zohar@linux.vnet.ibm.com>
	<20110919141911.e13569ab.akpm@google.com>
	<1316471708.3191.130.camel@localhost.localdomain>
	<20110919153810.ba0be83a.akpm@google.com>
Date: Tue, 20 Sep 2011 09:04:00 +0300
Message-ID: <CAHp75VefX=KUGarhc9QK41AN6_MbxkrGWMHk7_40g0TMcLhgzg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/5] lib: add unpack_hex_byte()
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@google.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        David Safford <safford@watson.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 1:38 AM, Andrew Morton <akpm@google.com> wrote:
>> > Finally, the name is poor.  It starts with "unpack_", so it belongs to
>> > the "unpack" subsystem.  There's no such thing.  Something like
>> > hex_byte_to_bin() would be better.
>>
>> agreed.  It was suppose to parallel the existing pack_hex_byte().
>
> hex_byte_pack() :)
Have you just proposed to do mass rename of pack_hex_byte() to the
hex_byte_pack()?

-- 
With Best Regards,
Andy Shevchenko
