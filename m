Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892Ab0FTGT7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 02:19:59 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37543 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339Ab0FTGT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 02:19:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        b=LVjH8PxHuzUi7wX30NDkoouj+OIWdPTX0uNwj6CHhnHdayE+CTOOgIeA2o7AbDMtSv
         27lPYNNINUv0MDh4enINnb5vtA6evTkNPJONPC/LTRRMiW8oKVd15GoFIu+IrheTciq8
         pHuFo4I8RS4U3Zz8c7vG43rGFoj963k7MNwpg=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20100619195242.GS18946@basil.fritz.box>
References: <200912081016.198135742@firstfloor.org> <20091208211647.9B032B151F@basil.firstfloor.org> 
	<AANLkTimBhQAYn7BDXd1ykSN90v0ClWybIe2Pe1qv_6vA@mail.gmail.com> 
	<20100619132055.GK18946@basil.fritz.box> <AANLkTin-lj5ZgtcvJhWcNiMuWSCQ39N8mqe_2fm8DDVR@mail.gmail.com> 
	<20100619133000.GL18946@basil.fritz.box> <AANLkTiloIXtCwBeBvP32hLBBvxCWrZMMwWTZwSj475wi@mail.gmail.com> 
	<20100619140933.GM18946@basil.fritz.box> <AANLkTilF6m5YKMiDGaTNuoW6LxiA44oss3HyvkavwrOK@mail.gmail.com> 
	<20100619195242.GS18946@basil.fritz.box>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 20 Jun 2010 08:19:35 +0200
Message-ID: <AANLkTikMZu0GXwzs6IeMyoTuhETrnjZ1m5lI9FTauYBA@mail.gmail.com>
Subject: Re: [PATCH] [31/31] HWPOISON: Add a madvise() injector for soft page 
	offlining
To: Andi Kleen <andi@firstfloor.org>
Cc: fengguang.wu@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,
On Sat, Jun 19, 2010 at 9:52 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> .TP
>> .BR MADV_SOFT_OFFLINE " (Since Linux 2.6.33)
>> Soft offline the pages in the range specified by
>> .I addr
>> and
>> .IR length .
>> This memory of each page in the specified range is copied to a new page,
>
> Actually there are some cases where it's also dropped if it's cached page.
>
> Perhaps better would be something more fuzzy like
>
> "the contents are preserved"

The problem to me is that this gets so fuzzy that it's hard to
understand the meaning (I imagine many readers will ask: "What does it
mean that the contents are preserved"?). Would you be able to come up
with a wording that is a little miore detailed?

>> and the original page is offlined
>> (i.e., no longer used, and taken out of normal memory management).

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface" http://blog.man7.org/
