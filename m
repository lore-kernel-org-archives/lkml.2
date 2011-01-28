Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712Ab1A1Xsy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 18:48:54 -0500
Received: from na3sys010aog112.obsmtp.com ([74.125.245.92]:47449 "HELO
	na3sys010aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752706Ab1A1Xsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 18:48:53 -0500
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Fri, 28 Jan 2011 18:48:53 EST
MIME-Version: 1.0
In-Reply-To: <AANLkTimLbkqmkijkLk+kALOUK6TVB0AJA3Ca+X-wcjpQ@mail.gmail.com>
References: <1295800203-9552-1-git-send-email-ralf.thielow@googlemail.com> <AANLkTimLbkqmkijkLk+kALOUK6TVB0AJA3Ca+X-wcjpQ@mail.gmail.com>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 28 Jan 2011 15:41:42 -0800
X-Google-Sender-Auth: VGjRCiHNQ8EfJ9vPfwxs3YxIfvU
Message-ID: <AANLkTimapHEPRcHDYuyksORHdRkEFVKyEyM=BM_0iZr4@mail.gmail.com>
Subject: Re: [PATCH] infiniband: hw: amso1100: Fixed compile warning.
To: Bart Van Assche <bvanassche@acm.org>
Cc: Ralf Thielow <ralf.thielow@googlemail.com>, tom@opengridcomputing.com,
        swise@opengridcomputing.com, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Have you considered using "0" instead of "(u64) NULL" or "(unsigned
> long) NULL" ?

I applied a new version of the patch with 0 instead of (unsigned long)
NULL, thanks.
