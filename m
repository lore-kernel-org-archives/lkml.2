Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755903Ab0JDNlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 09:41:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60011 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755820Ab0JDNlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 09:41:16 -0400
Message-ID: <4CA9D97A.7020109@suse.cz>
Date: Mon, 04 Oct 2010 15:41:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Will Newton <will.newton@gmail.com>
Cc: =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: Use PATH_MAX instead of 128 for path buffer
 sizes.
References: <AANLkTinwXj92VLVYqDhvUAusY_MdBQPAYnGBKVgfNLrO@mail.gmail.com>	<20100924093206.GD5453@cr0.nay.redhat.com> <AANLkTi=ykH+gTujw+x1c107V6wXfZUT66uHBQ1o6NgK+@mail.gmail.com>
In-Reply-To: <AANLkTi=ykH+gTujw+x1c107V6wXfZUT66uHBQ1o6NgK+@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4.10.2010 15:00, Will Newton wrote:
> On Fri, Sep 24, 2010 at 10:32 AM, Américo Wang <xiyou.wangcong@gmail.com> wrote:
>> On Wed, Sep 22, 2010 at 03:59:13PM +0100, Will Newton wrote:
>>> This prevents the buffers being overflowed when using a config
>>> file with a long name. PATH_MAX is used elsewhere in the same
>>> file, so use it here as well.
>>>
>>> Signed-off-by: Will Newton <will.newton@imgtec.com>
>>
>> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>>
>> Thanks!
> 
> Ping!
> 
> Could someone take this please?

Sorry, applied now. BTW, please do not send patches inline _and_ as
attachments at the same time, it confuses git am.

Michal
