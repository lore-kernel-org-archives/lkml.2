Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142Ab2HAKsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:48:24 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:47682 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753639Ab2HAKsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:48:19 -0400
MIME-Version: 1.0
In-Reply-To: <CADKZ3FLs444RfLx=RyBPKs+Lza_mZHhT=zHauMt3BUnqAUtY0w@mail.gmail.com>
References: <CADKZ3FKDw78ac9JPXJuw0s7Mqg1RrVfonbjXZ6zHmtwF2i5HoQ@mail.gmail.com>
	<1343765698.4474.10.camel@jlt3.sipsolutions.net>
	<CADKZ3FLs444RfLx=RyBPKs+Lza_mZHhT=zHauMt3BUnqAUtY0w@mail.gmail.com>
Date: Wed, 1 Aug 2012 14:48:18 +0400
Message-ID: <CADKZ3FKTu7yT17EBHbHcgZhB-PZ-KECbGd2HZ-WfMb-t7qDwtg@mail.gmail.com>
Subject: Re: wlcore: might_sleep operation in interrupt handler
From: Denis Yefremov <yefremov.denis@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Luciano Coelho <coelho@ti.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        Eliad Peller <eliad@wizery.com>, Arik Nemtsov <arik@wizery.com>,
        Eyal Shapira <eyal@wizery.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ldv-project@ispras.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry. My mistake. In this case it seems that sleep functions can
be called from thread_fn, since interrupt line is disabled globally.
And nothing bad will happen if you know that device can be
blocked for relatively long time.
