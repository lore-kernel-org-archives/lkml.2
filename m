Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab1EMGjo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:39:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:37411 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab1EMGjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:39:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=MFv13DE6lysVkaPmOPGWh+UK0YVGHa1zCSeRxfnSJp5G8VyQg3gOa2rD7v2R2LBtOZ
         OwP+xYFTpslugUJ8RBo4Ekm8BDb3v1vtOoc8Vhce1z5PfWRLqy2yNFy0rVKJ/Pw5kGPB
         kmGrBKJvLVH++4bj6410s69JgONVoyU6m4jqg=
MIME-Version: 1.0
In-Reply-To: <201105122127.44484.rjw@sisk.pl>
References: <1305220265-9020-1-git-send-email-lamiaposta71@gmail.com>
	<201105122127.44484.rjw@sisk.pl>
Date: Fri, 13 May 2011 08:39:42 +0200
Message-ID: <BANLkTikZkRW6TWMcWyZC4_TdAWgjXDqvYA@mail.gmail.com>
Subject: Re: pm loss development
From: Raffaele Recalcati <lamiaposta71@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@lists.linux-foundation.org,
        davinci-linux-open-source@linux.davincidsp.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

2011/5/12 Rafael J. Wysocki <rjw@sisk.pl>:
> On Thursday, May 12, 2011, Raffaele Recalcati wrote:
>> What happen normally in runtime pm implementation is that every devices
>> are switched off and are enabled only when needed.
>> In our case instead we have a completely functional embedded system and,
>> when an asyncrhonous event appear, we have only some tens milliseconds
>> before the actual power failure takes place.
>> This patchset add a support in order to switch off not vital part of the system,
>> in order to allow the board to survive longer.
>> This allow the possibility to save important data.
>
> OK, so first, who decides what parts of the system are vital and what aren't?

Take a quick look at Documentation/power/loss.txt  paragrpah "2.4
Power loss policies".
You can decide what can be powered off.

Thanks,
Raffaele



-- 
www.opensurf.it
