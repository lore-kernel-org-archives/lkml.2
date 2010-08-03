Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0HCKur (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:50:47 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41283 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194Ab0HCKup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:50:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=sIVdgUn5kP89ipxtE/S8ry+ze2jWLC4+5I8ZF90duc6gV/9UJ6xwQ8SDGVbYlrzC+S
         bfLlWAkeG5kW7Ccp1TOlB82Dk+WyJc2wF8HLEmCHmU2YBh/qFSGdCHHkv2zXtLtFTal7
         U5C6aJFnC6j5L5ZAUFhwbmdBq0LIMSI0lvICw=
MIME-Version: 1.0
In-Reply-To: <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282320.39528.linux@rainbow-software.org>
	<201007282334.08063.rjw@sisk.pl>
	<20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 3 Aug 2010 12:50:43 +0200
Message-ID: <AANLkTim5STgpNEdh3JSU_BG5X8Wxh-gbXDmWYLdufNb3@mail.gmail.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
From: Andrea Gelmini <andrea.gelmini@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>, nigel@tuxonice.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/29 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>:
> Considering possible cases...and here is a patch.
> but I'm not fully sure. Could you clarify ?

I'm using this patch (with the one for ksm.c by Arcangeli) since the publishing.
It seems all works pretty well, with TuxOnIce also.

Never had the need to reboot the system.

Thanks a lot,
Andrea
