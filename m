Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab1EBP2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 11:28:31 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:33746 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254Ab1EBP2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 11:28:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:reply-to:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Dyn40NlTQZ1YX9wvWIf4CPLoeEGitpNHhYbqlE7bO/LeZF7D8Vb4nwJ3kU2qCQAHKQ
         vs+7Bz9A+vSsizYlhbw99tHtCH4RPYS047Lp3uwU3cCuN84rORaZVL3Ls3JrJQeVWYOB
         n7PdscbuEcI0ig8066XDRli7ZraYdRz5yVPkQ=
MIME-Version: 1.0
Reply-To: wanlong.gao@gmail.com
In-Reply-To: <20110502152337.GA7364@kroah.com>
References: <20110502143845.GA4952@gmail.com>
	<20110502152337.GA7364@kroah.com>
Date: Mon, 2 May 2011 23:28:29 +0800
X-Google-Sender-Auth: 3ziGMz9wjQw6LU94KBRYsPbO388
Message-ID: <BANLkTim3JaS-7dgLYQiQhC9MyqROcBFMxA@mail.gmail.com>
Subject: Re: [PATCH]Remove a warning for drivers/staging/wlan-ng/cfg80211.c
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com, joe@perches.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harry .
It seems like that you send the patch dup.
I saw the same one from you last week .

Thanks

On 5/2/11, Greg KH <greg@kroah.com> wrote:
> On Mon, May 02, 2011 at 10:38:49PM +0800, Harry Wei wrote:
>> From: Harry Wei <harryxiyou@gmail.com>
>>
>> 	When i was compiling kernel, a warning happened to me.
>>   The warning said like following.
>>
>> drivers/staging/wlan-ng/cfg80211.c:709: warning: initialization from
>> incompatible pointer type.
>>
>> See
>> http://s1202.photobucket.com/albums/bb364/harrywei/?action=view&current=patched2.png
>> for more details.
>>
>> So i patch like following.
>>
>> Signed-off-by: Harry Wei <harryxiyou@gmail.com>
>> Acked-by: Randy Dunlap <randy.dunlap@oracle.com>
>> ---
>>  drivers/staging/wlan-ng/cfg80211.c |    2 +-
>
> I'm pretty sure this was included in the set of patches sent to Linux
> last week, right?
>
> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
