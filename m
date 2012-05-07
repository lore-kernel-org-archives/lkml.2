Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab2EGS0l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 14:26:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33992 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756334Ab2EGS0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 14:26:39 -0400
MIME-Version: 1.0
In-Reply-To: <1336408965.2385.25.camel@dcbw.foobar.com>
References: <20120427094637.GV3157@wantstofly.org>
	<CA+icZUXNZ=exTnR=OgD_9bpt_0s-KnR+v-K6u+XzQr4HBoTQHQ@mail.gmail.com>
	<20120427095842.GW3157@wantstofly.org>
	<CA+icZUWuynSaPE4pdxzoP783pw7r=5x27ewXN_pkR5VS=0kKUg@mail.gmail.com>
	<20120427101732.GX3157@wantstofly.org>
	<CA+icZUUnJPeDmL9xXfvj62an40bXwwaOnrJmxmLN_cBt9PyCZA@mail.gmail.com>
	<CA+icZUV76wSBj88EpzmWbO=u2dP23yi5P98nN2KZehBUni9mEg@mail.gmail.com>
	<20120427185809.GZ3157@wantstofly.org>
	<CA+icZUWQmCRdjucb4+Nf24_zbJ4fzzp7zjqhKjXE6U01rppDfA@mail.gmail.com>
	<CA+icZUXSaEMA=KbQP9UQcU6ZMBh8QD2sv-O=6r_Ly8is==gvSA@mail.gmail.com>
	<20120501125102.GN3157@wantstofly.org>
	<1336406944.2385.24.camel@dcbw.foobar.com>
	<1336408965.2385.25.camel@dcbw.foobar.com>
Date: Mon, 7 May 2012 11:26:39 -0700
X-Google-Sender-Auth: NYdi8QYGDB3nmlMWRtpFq9cR3Do
Message-ID: <CAJ-Vmok92fR_JfqD2BrnP7A0c8Vs5K7T-77nzt7B+sPPgk6KNw@mail.gmail.com>
Subject: Re: [PATCH] mwl8k: Add 0x2a02 PCI device-id (Marvell 88W8361)
From: Adrian Chadd <adrian@freebsd.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Lennert Buytenhek <buytenh@wantstofly.org>, sedat.dilek@gmail.com,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lautriv <admin@coldplug.net>,
        Jim Cromie <jim.cromie@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Let me see if the topdog firmware that FreeBSD ships with supports hostap mode.

I'm having aggregation issues but I think that's driver side, not firmware side.



Adrian
