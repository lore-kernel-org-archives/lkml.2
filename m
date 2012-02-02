Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932209Ab2BBUuu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:50:50 -0500
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:37345 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932119Ab2BBUut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:50:49 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1202022116280.16704@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1202022116280.16704@swampdragon.chaosbits.net>
From: Roland Dreier <roland@kernel.org>
Date: Thu, 2 Feb 2012 12:50:27 -0800
X-Google-Sender-Auth: IkfMwW9RLewEm-myUD_P_fPzgHE
Message-ID: <CAL1RGDWRB2AND0LO1K6+PFiqF=Tm7E+MG4uAu0TqaXLp+qPrKg@mail.gmail.com>
Subject: Re: [PATCH] Infiniband: Remove unneeded version.h include from drivers/infiniband/ulp/srpt/ib_srpt.h
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-rdma@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        linux-kernel@vger.kernel.org, trivial@kernel.org,
        target-devel <target-devel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.

Nic, I assume it's OK with you if I merge trivial srpt patches like this?

 - R.
