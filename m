Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab1GSEUA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 00:20:00 -0400
Received: from na3sys010aog104.obsmtp.com ([74.125.245.76]:43317 "HELO
	na3sys010aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750788Ab1GSET7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 00:19:59 -0400
MIME-Version: 1.0
In-Reply-To: <3bf562d8c92207221d39b2c96af4731308324d61.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
References: <cover.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de> <3bf562d8c92207221d39b2c96af4731308324d61.1308142053.git.manuel.f.zerpies@ww.stud.uni-erlangen.de>
From: Roland Dreier <roland@kernel.org>
Date: Mon, 18 Jul 2011 21:19:38 -0700
X-Google-Sender-Auth: INajEDYD-7Y9kVW-CFtUsbAhp-o
Message-ID: <CAL1RGDWCED4-3aD1A_o3k2mGU+fmeRsfswooRjCMtKtJjqnU2A@mail.gmail.com>
Subject: Re: [PATCH 05/11] RDMA/hw/cxgb4: use printk_ratelimited() instead of printk_ratelimit()
To: Manuel Zerpies <manuel.f.zerpies@ww.stud.uni-erlangen.de>
Cc: Steve Wise <swise@chelsio.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        christian.dietrich@informatik.uni-erlangen.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.
