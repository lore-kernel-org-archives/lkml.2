Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab1HEMQk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 08:16:40 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:47406 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab1HEMQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 08:16:39 -0400
MIME-Version: 1.0
In-Reply-To: <20110803211225.GA24876@ioremap.net>
References: <1312310811-17327-1-git-send-email-vzapolskiy@gmail.com>
	<20110803211225.GA24876@ioremap.net>
Date: Fri, 5 Aug 2011 15:16:38 +0300
X-Google-Sender-Auth: M8NPdusXQ9D-13TFWhueQTaQ-_8
Message-ID: <CAMW3pwZqRRZKpDeGYbEEGV-8GMAUHHWvGNje1orHs9YGp7ErUA@mail.gmail.com>
Subject: Re: [PATCH] connector: add comm change event report to proc connector
From: Vladimir Zapolskiy <vzapolskiy@gmail.com>
To: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 4, 2011 at 12:12 AM, Evgeniy Polyakov <zbr@ioremap.net> wrote:
> On Tue, Aug 02, 2011 at 09:46:51PM +0300, Vladimir Zapolskiy (vzapolskiy@gmail.com) wrote:
>> This change adds an event to monitor comm value changes of tasks. Such
>> an event becomes vital, if someone desires to control threads of a
>> process in different manner.
>
>> Signed-off-by: Vladimir Zapolskiy <vzapolskiy@gmail.com>
>> Cc: Evgeniy Polyakov <zbr@ioremap.net>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>
> Looks good.
> Acked-by: Evgeniy Polyakov <zbr@ioremap.net>
>

Thanks a lot, hopefully that's the end of my foray into connector :)

Andrew, unfortunately I can't find a proper tree for integration,
could I kindly ask you to pick up the change, if it's possible for
you?

-- 
With best regards,
Vladimir
