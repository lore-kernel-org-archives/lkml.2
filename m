Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab1ENUer (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 16:34:47 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:37811 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab1ENUeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 16:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ptArDa10TIPopLoyHpVl6kJTptDQ9pIY6Z1zRrsR6fPtCbDlXXgEWP9RLlL1iFT803
         m34Hqbyn8NNV2pyXJpXj2/7PW27MpaYJ0+mKS97hd2QdiXh3ORa7C9UXOetMIee7x87s
         eb/BqeyzsJgI9gb5dkK3AeeMAsXoLKXdIPlko=
MIME-Version: 1.0
In-Reply-To: <201105142053.34920.oliver@neukum.org>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
	<201105122127.44484.rjw@sisk.pl>
	<201105142053.34920.oliver@neukum.org>
Date: Sat, 14 May 2011 22:34:09 +0200
Message-ID: <BANLkTikEJoV1JHMDZODvv40-8-jmvYMbgg@mail.gmail.com>
Subject: Re: [linux-pm] pm loss development
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 14, 2011 at 8:53 PM, Oliver Neukum <oliver@neukum.org> wrote:
> Am Donnerstag, 12. Mai 2011, 21:27:44 schrieb Rafael J. Wysocki:
>> On Thursday, May 12, 2011, Raffaele Recalcati wrote:
>> > What happen normally in runtime pm implementation is that every devices
>> > are switched off and are enabled only when needed.
>> > In our case instead we have a completely functional embedded system and,
>> > when an asyncrhonous event appear, we have only some tens milliseconds
>> > before the actual power failure takes place.
>> > This patchset add a support in order to switch off not vital part of the system,
>> > in order to allow the board to survive longer.
>> > This allow the possibility to save important data.
>>
>> OK, so first, who decides what parts of the system are vital and what aren't?
>
> If you know that power is failing in a few miliseconds, only stuff that can lead to data
> corruption is vital. In that timeframe you can't even flush buffers.

Remember that if you switch off some peripherals this timeframe
becomes longer, so maybe you have enough time to sync some storage
devices.

Bye,
Raffaele
