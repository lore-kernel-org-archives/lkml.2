Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759176Ab2EDQfG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 12:35:06 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62440 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134Ab2EDQfF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 12:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <1336124366.2046.20.camel@t41.thuisdomein>
References: <CADDKRnDR=baZtQfyQLxYGB2zVDMGi2C_V2ffNkSUhipJB-+t=A@mail.gmail.com>
	<1335995781.30754.27.camel@x61.thuisdomein>
	<CADDKRnA7XMczevE2JRsMR508mdz+Rgs+QvV4QCMqnts8t+1y3A@mail.gmail.com>
	<1336124366.2046.20.camel@t41.thuisdomein>
Date: Fri, 4 May 2012 18:35:02 +0200
Message-ID: <CADDKRnCz1wfcUKdPCFzMya3kr3f-gRuQoopiYa1fZ55VtAjxXw@mail.gmail.com>
Subject: Re: [v3.4-rc5]: drm references experimental
From: =?ISO-8859-1?Q?J=F6rg_Otte?= <jrg.otte@googlemail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK, thanks again Paul, for your answeres.
Jörg

2012/5/4 Paul Bolle <pebolle@tiscali.nl>:
> On Thu, 2012-05-03 at 14:02 +0200, Jörg Otte wrote:
>> this means especially the following is not possible or does not occure:
>>
>> NON-EXP:
>> driver "A" uses library function "B"
>>
>> EXP:
>> unchanged driver "A" now uses EXPERIMENTAL function "B-EXP"
>
> There's a number of things I can think of for "EXPERIMENTAL function".
> What exactly do you mean here?
>
>> The question is whether this is guaranteed.
>
> If you were thinking about usage of CONFIG_EXPERIMENTAL in code or in
> Makefiles: no, I don't think there's a guarantee that this won't be
> done. But it should be clear that EXPERIMENTAL is intended as, say, a
> tag for config options. So it's likely that usage of EXPERIMENTAL
> outside that scope will be prevented.
>
>
> Paul Bolle
>
