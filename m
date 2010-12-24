Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab0LXXnB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 18:43:01 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41679 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab0LXXm7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 18:42:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eMe+3CEaKzhNkDv7H7Ltc38Y6pG8VzbYOVb6LJf3Is46xSKtmZEDU8TCcGRxmsI0TY
         3PDK2iLsNdesGSqc5LbE9HCXg/aBJq2s86Ym1xIdwjZXG1M/CDUIrjq1Q0CRpE8yuSU2
         F510Iejw86iHRsl0nDB7HHi1cJsk/JI4bhiiA=
MIME-Version: 1.0
In-Reply-To: <4D145016.60906@free.fr>
References: <Pine.LNX.4.44L0.1012231755180.11535-100000@netrider.rowland.org>
	<36f50535272fab60e974dc75e172bf29@secure211.sgcpanel.com>
	<4D145016.60906@free.fr>
Date: Sat, 25 Dec 2010 00:42:58 +0100
Message-ID: <AANLkTik9ByQpPCf3jNsotB__a_p3JxaiK7fA-E-K91U3@mail.gmail.com>
Subject: Re: 2.6.37-rc7: no more shutdown on DELL E6400
From: Alessandro Suardi <alessandro.suardi@gmail.com>
To: eric.valette@free.fr
Cc: Felipe Balbi <me@felipebalbi.com>, Alan Stern <stern@rowland.harvard.edu>,
        Randy Dunlap <rdunlap@xenotime.net>, lud <linux-usb@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 8:47 AM, Eric Valette <eric.valette@free.fr> wrote:
> On 24/12/2010 00:56, Felipe Balbi wrote:
>>
>> Hi,
>
>> I've got an E6400 myself and the only time I could get
>> it to hang was when trying to use brcm80211 driver from
>> staging. The problem appears when I rmmod/modprobe the
>> driver after it looses connection to my wifi router.
>>
>> Since the driver is still in staging and buggy as hell
>> I didn't bother notifying anyone. But it's true that
>> shutdown truly hangs.
>>
>> Are you using brcm80211 driver too ?
>>
>
> No. Mine has an Intel WiFi chipset. With DELL the same reference can be used
> for multiple different hardware instantiation (I have a nvidia vido chipset
> some seems now to have an intel one).
>
> PS: For me the hang appeared with 2.6.37-rc7. I run linux on it for more
> than a year changing stable kernel as soon as they appear and usually trying
> future kernel around rc6 stage.
>
> 2.6.36.2 works perfectly. I did not change my config except maybe if the
> make oldconfig was proposing something obvious (e.g new generic MII
> support).

Just as a data point, my Dell E6400 still shuts down fine in both 2.6.37-rc7
 and -rc7-git2. This one has integrated Intel video (i915) and I use the
 out-of-tree broadcom-sta driver for the wireless interface. If needed, I can
 post my .config in the bugzilla entry (but won't, unless asked - in order to
 avoid possible bug noise).

--alessandro

 "There's always a siren singing you to shipwreck"

   (Radiohead, "There There")
