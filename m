Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435Ab1EWLuX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 07:50:23 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:35681 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717Ab1EWLuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 07:50:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=budlq6FAO9sjj0u8nT/RMaFbTB6cklh1t7FONBdanm+YXvcH/josUOhjBfJ664buvN
         eL/ZvtUZtABRagQjwKG47NHZ+2LSt/ysK+pWnP9UcBKFhgB8JdHGyoETD2NM1rinNkd9
         SXXqhtK0B/xZknfEogqH/C/meaFUL7EObrj6k=
MIME-Version: 1.0
In-Reply-To: <20110523112558.GC11439@tiehlicka.suse.cz>
References: <BANLkTinLvqa0DiayLOwvxE9zBmqb4Y7Rww@mail.gmail.com>
	<20110523112558.GC11439@tiehlicka.suse.cz>
Date: Mon, 23 May 2011 19:50:21 +0800
Message-ID: <BANLkTi=2SwKFfwBxrQr3xLYSUzoGOy6oKA@mail.gmail.com>
Subject: Re: [Patch] mm: remove noswapaccount kernel parameter
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 7:25 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 23-05-11 19:08:08, Am??rico Wang wrote:
>> noswapaccount is deprecated by swapaccount=0, and it is scheduled
>> to be removed in 2.6.40.
>
> Similar patch is already in the Andrew's tree

Ah, my google search failed to find it. :-/

> (memsw-remove-noswapaccount-kernel-parameter.patch). Andrew, are you
> going to push it?
> Btw. the patch is missing documentation part which is present here.
>

Hmm, maybe I should send a delta patch... Andrew?

Thanks!
