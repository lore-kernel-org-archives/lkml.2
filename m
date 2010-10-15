Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932570Ab0JOUNo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:13:44 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51012 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932413Ab0JOUMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:12:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=tIZkHW3Zw2e7JXGqzYHFPTc+IdVVMeREzshVJ/t7CQCCg0X8MAhWvew2xCI6FtFJIN
         MmQUUNC0qW2sO0z8VWuekeqVmYsgtfjR74QI1qTL5apUe+IWtqBPzsL+by4f+Mk1S7Ng
         MemQLhkuLSlGgBJRqwfrRYiRCZBsMILRbMeMo=
From: Christian Lamparter <chunkeey@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly instead of depending on flush_scheduled_work()
Date: Fri, 15 Oct 2010 22:07:31 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-wl+; KDE/4.4.5; x86_64; ; )
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
References: <4CB874C0.8090003@kernel.org> <20101015192645.GA2438@tuxdriver.com> <4CB8AC80.7090802@kernel.org>
In-Reply-To: <4CB8AC80.7090802@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201010152207.31553.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 21:33:20 Tejun Heo wrote:
> Hello,
> 
> On 10/15/2010 09:26 PM, John W. Linville wrote:
> >> wireless-testing/wireless-next has already such a patch:
> >> "mac80211: cancel restart_work in ieee80211_unregister_hw" (2010-08-25)
> >>
> >> <http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=258086a48b766d12a500f98834654ffa927ca475>
> >>
> >> John, can you please push to 2.6.36-rc8?
> >> (I know, I am _late_, but I didn't know about any potential problem
> >> in the mainline?)
> > 
> > I don't see how either patch would merit inclusion in 2.6.36 at this point.
> 
> My patch definitely was aimed for 2.6.37-rc1 or later.
Oh, so the "[PATCH v2.6.36-rc7]" in the patch subject was just "misleading" me.
no-one could have known that there would be a 2.6.36-rc8 release.

John, please ignore my previous request of pushing the patch into 2.6.36 ;).
 
Regards,
	Chr
