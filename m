Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754739Ab2GaJy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 05:54:26 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:6921 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753246Ab2GaJyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 05:54:24 -0400
Message-ID: <5017AB41.60700@parallels.com>
Date: Tue, 31 Jul 2012 13:54:09 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "lwn@lwn.net" <lwn@lwn.net>, "criu@openvz.org" <criu@openvz.org>,
        "users@openvz.org" <users@openvz.org>,
        Containers <containers@lists.linux-foundation.org>,
        cgroups mailinglist <cgroups@vger.kernel.org>
Subject: Re: [Announce] Checkpoint-restore tool v0.1
References: <500D09C9.7060903@parallels.com> <500D1116.7070301@parallels.com> <CAFLxGvwUhEPNdQvUnue2QFu_EipmBKD3nf0MfMWkqwLTf7jd5Q@mail.gmail.com> <50179CF0.7050200@parallels.com> <CAFLxGvygCxER3gHfj-onwnm_m6xugOVkynGyJU2CDheD3A2HOQ@mail.gmail.com> <5017A053.9000206@parallels.com> <CAFLxGvy396+BfYSaSnvAwJb0GO4WZCKbPXSbU7YfrOJTo6zk6A@mail.gmail.com>
In-Reply-To: <CAFLxGvy396+BfYSaSnvAwJb0GO4WZCKbPXSbU7YfrOJTo6zk6A@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/31/2012 01:29 PM, richard -rw- weinberger wrote:
> On Tue, Jul 31, 2012 at 11:07 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
>> Sorry :( However, if you can help with patches on that issue that would be
>> highly appreciated :)
>>
> 
> Yeah, but I fear it's not that easy.
> We'd have to change crtools to work without ptrace().

Well, this is hard. Using ptrace saved us from having many special-purpose
APIs for dumping various stuff (there will be an article about it). Thus I
don't know which way is simpler -- stop using ptrace or teach ptrece to allow
several tracers to attach to one task %)

Thanks,
Pavel

