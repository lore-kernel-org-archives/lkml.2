Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2A0SAJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:00:09 -0500
Received: from na3sys010aog111.obsmtp.com ([74.125.245.90]:41066 "HELO
	na3sys010aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752858Ab2A0SAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:00:06 -0500
MIME-Version: 1.0
In-Reply-To: <35AAF1E4A771E142979F27B51793A4888885970586@AVEXMB1.qlogic.org>
References: <1326102050-30265-1-git-send-email-Julia.Lawall@lip6.fr> <35AAF1E4A771E142979F27B51793A4888885970586@AVEXMB1.qlogic.org>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 27 Jan 2012 09:59:44 -0800
X-Google-Sender-Auth: sAdLIyx_h6wPgFrYkOKhhhevqm8
Message-ID: <CAL1RGDXxNZCdbsEkBjFdzKKg769pA1E3Vs2zCCVM2HBWVPUS0w@mail.gmail.com>
Subject: Re: [PATCH 1/4] drivers/infiniband/hw/qib/qib_iba6120.c: convert
 GFP_KERNEL to GFP_ATOMIC
To: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>,
        Dept_Infinipath <Dept_Infinipath@qlogic.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, applied.
