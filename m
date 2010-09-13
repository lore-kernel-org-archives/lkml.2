Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755033Ab0IMTCX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:02:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54157 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab0IMTCU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:02:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=bjm7USVpobZsw5jQJXtuR4pTDQggDAxxP3BPz+Qod7h1u60ckntFUj7ghAsEz8/lyp
         e9ydha59PNCbR1fDS+qjxsSU+ouD0EB81d425x7/8w59c1hIknQwsIhz48YElqDR2uNm
         CZ50mf+LUT9ZJ2wBm+DmzNp91fMp1gUAz2WdI=
MIME-Version: 1.0
In-Reply-To: <87vd69v8v3.fsf@gmail.com>
References: <20100912210444.76ebeee6@tron.localdomain> <20100912223724.GA15934@electric-eye.fr.zoreil.com>
 <20100913095912.74d7f0f1@tron.localdomain> <87vd69v8v3.fsf@gmail.com>
From: dave b <db.pub.mail@gmail.com>
Date: Tue, 14 Sep 2010 05:01:58 +1000
Message-ID: <AANLkTinmAAhq8ffzKHearW48rkJZDdZH4uekW==uUh0y@mail.gmail.com>
Subject: Re: Realtek Ethernet drivers
To: Ben Gamari <bgamari@gmail.com>
Cc: Heiko Bauke <heiko.bauke@snafu.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 September 2010 03:41, Ben Gamari <bgamari@gmail.com> wrote:
> On Mon, 13 Sep 2010 09:59:12 +0200, Heiko Bauke <heiko.bauke@snafu.de> wrote:
>> > But it misses 81a95f049962ec20a9aed888e676208b206f0f2e and
>> > 024a07bacf8287a6ddfa83e9d5b951c5e8b4070e
>>
>> I thank you for your reply. If there is time I will try a more recent
>> kernel. (For the moment the Realtek drivers are fine for me.) I
>> know how to (re-)compile distribution kernels and how to compile a
>> vanilla kernel from kernel.org. However, I have no idea what the
>> hex-codes you mentioned mean. Can you give me a hint?
>>
> These are git (the version control system used for kernel development)
> commit ids.

Please add https://launchpad.net/~kernel-ppa/+archive/ppa
and install the latest kernel available from that repository if you
are unsure as to how to compile a kernel.org kernel.
