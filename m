Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab2IIUux (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 16:50:53 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:42728 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab2IIUuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 16:50:51 -0400
Message-ID: <504D0127.5080807@pobox.com>
Date: Sun, 09 Sep 2012 16:50:47 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Arvydas Sidorenko <asido4@gmail.com>, Zheng Liu <wenqing.lz@taobao.com>,
        linux-kernel@vger.kernel.org,
        IDE/ATA development list <linux-ide@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Storage related regression in linux-next 20120824
References: <CA+6av4=uxu_q5U_46HtpUt=FSgbh3pZuAEY54J5_xK=MKWq-YQ@mail.gmail.com> <CAFtxgO536xEMjMw_D1u3utT1f1iy-6EsjcawdYvbocRxc=Wu=A@mail.gmail.com> <503BA2DB.9080704@gmail.com> <503BB4BB.4080307@gmail.com> <alpine.LSU.2.00.1209090012390.2416@eggly.anvils> <CA+6av4=6WeLcde5me2FCpBtQJAOTtHZvf4pkMExgMW9agVNLWg@mail.gmail.com> <504CFBE3.401@pobox.com> <CANsGZ6aPB6ZjTmUJ=xeLY68iV5V9ghGGAQrp9KvJcyC0d-ARUg@mail.gmail.com>
In-Reply-To: <CANsGZ6aPB6ZjTmUJ=xeLY68iV5V9ghGGAQrp9KvJcyC0d-ARUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2012 04:36 PM, Hugh Dickins wrote:
> On Sun, Sep 9, 2012 at 1:28 PM, Jeff Garzik <jgarzik@pobox.com> wrote:
>> I'll send Linus a patch to disable.
>
> Thanks, but no, the change in question hasn't reached Linus yet, it's
> just a linux-next or mmotm thing - isn't it?

Yep, libata-dev#upstream.  Sorry, got my own branches confused for a 
second there.

	Jeff




