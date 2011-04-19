Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab1DSBop (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 21:44:45 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63005 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985Ab1DSBol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 21:44:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=rj1QUE9/2aWNwiO1TwND4JGHF3/1bj6jykUYZpdU8C9bM3ai8Tq8fhtdfUMDk193Xq
         95tfJsEzHRTC0JGI3FxJr1fHXV67MoxZa9QMo5xEx9llUN8rfsIF/SZelu9nmp2Ifkpy
         bNoTVUroMPb4CX2yf6e4KONq9/9kuEEYim50k=
Message-ID: <4DACE8F4.2050807@gmail.com>
Date: Tue, 19 Apr 2011 09:44:20 +0800
From: Wanlong Gao <wanlong.gao@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: Alessio Igor Bogani <abogani@kernel.org>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Subject: Re: [PATCH 4/4] module: Use the binary search for symbols resolution
References: <1302960373-5309-1-git-send-email-abogani@kernel.org> <1302960373-5309-5-git-send-email-abogani@kernel.org> <BANLkTik9oekjUH6YXTda1P_dM231nEHQqA@mail.gmail.com> <87liz73tso.fsf@rustcorp.com.au>
In-Reply-To: <87liz73tso.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  2011-4-19 9:37, Rusty Russell wroted:
> On Sat, 16 Apr 2011 22:32:08 +0800, Wanlong Gao<wanlong.gao@gmail.com>  wrote:
>>> +	sym = bsearch(fsa->name, syms->start, syms->stop - syms->start,
>> As the bsearch func, why not change the syms->stop to syms->end ?
>> Hmm..Just a stupid suggestion.
>
>
> The names are derived from the linker symbols for end of sections, which
> is __stop_<sectionname>.
>
> Cheers,
> Rusty.
As this , why not change the bsearch's "end" to "stop", too ? It will be 
more readable.

Thanks
Wanlong
