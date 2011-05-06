Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120Ab1EFPor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 11:44:47 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55119 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751131Ab1EFPop convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 11:44:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=oqiQNG8KFgvx/Tdn/ilgQ8ElBmDMtchT7wyYb5S2V2KsAuvl+W+QVWGSgE2oXVB1lp
         Pp20XJbDH+bgdbkvvIXcVR7hJjGXsLamL/lXXa/d/fmF1nr5a0occXF1v95fVzVEbSkZ
         1hjX0oFqWQu73Kcq5Wha2zHzMyA24tAxKoADI=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110506084031.a1f2e483.randy.dunlap@oracle.com>
References: <20110506154921.47700781.sfr@canb.auug.org.au>
	<20110506084031.a1f2e483.randy.dunlap@oracle.com>
Date: Fri, 6 May 2011 17:44:44 +0200
Message-ID: <BANLkTimqboATe5cO+19Bv5p9dStnwevwng@mail.gmail.com>
Subject: Re: linux-next: Tree for May 6 (wireless)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 6, 2011 at 5:40 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
> On Fri, 6 May 2011 15:49:21 +1000 Stephen Rothwell wrote:
>
>> Hi all,
>>
>> Changes since 20110505:
>
>
> when PM is not enabled:
>
> net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no member named 'suspend'
> net/mac80211/main.c:700: error: 'const struct ieee80211_ops' has no member named 'resume'
>
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

There was a patch sent today, see "[PATCH] mac80211: Fix build error
when CONFIG_PM is not defined" from Larry.

- Sedat -
