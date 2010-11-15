Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0KOHTv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 02:19:51 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55941 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755875Ab0KOHTu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 02:19:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=oomME5r6bAfw8AbPr0mCgf6I2QgLEOnv5VkgnWjFvGxbIBXT/aYd0+8isbjM6vnyVB
         fstTvPD9tIp5/2UJQ1+lhGbcbIkcEjj8WfhL2iVAbmLk6xF4nzybFru0oroTw+SvuX25
         teDeTUFJm5N3xzFGkdD9xh9h0DyOjepxRAEsc=
MIME-Version: 1.0
In-Reply-To: <20101115160413.BF0F.A69D9226@jp.fujitsu.com>
References: <20101114140920.E013.A69D9226@jp.fujitsu.com>
	<AANLkTim59Qx6TsvXnTBL5Lg6JorbGaqx3KsdBDWO04X9@mail.gmail.com>
	<20101115160413.BF0F.A69D9226@jp.fujitsu.com>
Date: Mon, 15 Nov 2010 16:19:48 +0900
Message-ID: <AANLkTim0vCJkMoH5P0wCN9J6340rDsscyNBQ+R+_ph8m@mail.gmail.com>
Subject: Re: fadvise DONTNEED implementation (or lack thereof)
From: Minchan Kim <minchan.kim@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Ben Gamari <bgamari.foss@gmail.com>, linux-kernel@vger.kernel.org,
        rsync@lists.samba.org, linux-mm@kvack.org,
        Peter Zijlstra <peterz@infradead.org>,
        Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 4:09 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>> > Because we have an alternative solution already. please try memcgroup :)
>>
>> I think memcg could be a solution of them but fundamental solution is
>> that we have to cure it in VM itself.
>> I feel it's absolutely absurd to enable and use memcg for amending it.
>>
>> I wonder what's the problem in Peter's patch 'drop behind'.
>> http://www.mail-archive.com/linux-kernel@vger.kernel.org/msg179576.html
>>
>> Could anyone tell me why it can't accept upstream?
>
> I don't know the reason. And this one looks reasonable to me. I'm curious the above
> patch solve rsync issue or not.
> Minchan, have you tested it yourself?

Still yet. :)
If we all think it's reasonable, it would be valuable to adjust it
with current mmotm and see the effect.

>
>
>



-- 
Kind regards,
Minchan Kim
