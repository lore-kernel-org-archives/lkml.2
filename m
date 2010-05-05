Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab0EEHqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 03:46:31 -0400
Received: from mail-pz0-f204.google.com ([209.85.222.204]:37808 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751563Ab0EEHq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 03:46:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Tjf6s/X6Np8fqFl97mjmmaDT5gJnIeeGTkVzZTJ+YZYaHVwde+u4lGP7Rw2WHYRoUS
         HGgEt80Cn2B7/ooqIDA0tYn7oBn5chuGzb7c0cqwSRa9FV42VR+yYA7eJlSenQ92hHyD
         s/Jllv8ll3dqsXKOlhtZ1QAUeTELgpg5XK+LY=
MIME-Version: 1.0
In-Reply-To: <20100416112931.GN30801@buzzloop.caiaq.de>
References: <4BC8330E.6000503@bitsim.com> <20100416100126.GI30801@buzzloop.caiaq.de> 
	<4BC84766.5060208@bitsim.com> <4BC8493D.60900@bitsim.com> 
	<20100416112820.GM30801@buzzloop.caiaq.de> <20100416112931.GN30801@buzzloop.caiaq.de>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 5 May 2010 15:45:34 +0800
Message-ID: <n2mf17812d71005050045x4359dfeu2f563c3ac0a42223@mail.gmail.com>
Subject: Re: [PATCH] colibri.h: Fix building for colibri 270...
To: Daniel Mack <daniel@caiaq.de>
Cc: Jakob Viketoft <jakob.viketoft@bitsim.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 16, 2010 at 7:29 PM, Daniel Mack <daniel@caiaq.de> wrote:
> On Fri, Apr 16, 2010 at 01:28:20PM +0200, Daniel Mack wrote:
>> On Fri, Apr 16, 2010 at 01:25:49PM +0200, Jakob Viketoft wrote:
>> > Adding a "#include <mach/mfp.h>" seem to cure this problem. If you
>> > agree I can supply a new patch with the correct solution this time.
>>
>> Ok. Add it to colibri.h, and while at it, you can kick the ax88796.h
>> inclusion. That's a leftover and isn't needed.
>
> And Cc: stable@kernel.org for the backmerge to 2.6.33.
>

Jakob, any update on this?
