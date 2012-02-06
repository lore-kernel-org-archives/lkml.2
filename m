Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755552Ab2BFQ6b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 11:58:31 -0500
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:49753 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755397Ab2BFQ63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 11:58:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202042346510.30244@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202042346510.30244@swampdragon.chaosbits.net>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 6 Feb 2012 08:58:08 -0800
X-Google-Sender-Auth: ApErp7nK78MgXM5zXOn_RlwR2sg
Message-ID: <CAL1RGDUf8J_CYEzWanmNz=rvF+XcFsFVdQEH4ZgqNWORsXd5nQ@mail.gmail.com>
Subject: Re: [PATCH] IB: Don't return freed pointer from srpt_alloc_ioctx_ring()
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        Sean Hefty <sean.hefty@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good catch, applied, thanks!
