Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab0JOQ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:58:11 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49555 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932103Ab0JOQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:58:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=vZDa5/6jBwBn09Wv2roBDd9iJ6CPOqub4/lXAHfP+yLNwgEVvTq0wO7Vw8FO0eyYEj
         +wa/rzdfPa/QStevxre14AJG1cXStswSVlI6uiV4TpFPujBoG6+BjR5YcGP4mmrXdaNU
         Qdon8pBCQguOYzYty7D2OSzT4N7yeqSf0oroM=
From: Christian Lamparter <chunkeey@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] mac80211: cancel restart_work explicitly instead of depending on flush_scheduled_work()
Date: Fri, 15 Oct 2010 18:58:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-wl+; KDE/4.4.5; x86_64; ; )
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>
References: <4CB874C0.8090003@kernel.org> <1287159715.1870.11.camel@Nokia-N900-51-1> <4CB883C9.6050104@kernel.org>
In-Reply-To: <4CB883C9.6050104@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010151858.45000.chunkeey@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 October 2010 18:39:37 Tejun Heo wrote:
> Hello,

> >> -    /*
> >> -     * For key todo, it'll be empty by now but the work
> >> -     * might still be scheduled.
> >> -     */
> >> -    flush_scheduled_work();
> > 
> > oops, todo work no longer exists...
> > 
> > Anyway, ACK.
> 
> Are you going to route this through wireless tree?  Shall I repost
> with update patch description?

wireless-testing/wireless-next has already such a patch:
"mac80211: cancel restart_work in ieee80211_unregister_hw" (2010-08-25)

<http://git.kernel.org/?p=linux/kernel/git/linville/wireless-next-2.6.git;a=commit;h=258086a48b766d12a500f98834654ffa927ca475>

John, can you please push to 2.6.36-rc8?
(I know, I am _late_, but I didn't know about any potential problem
in the mainline?)

Best regards,
	Chr
