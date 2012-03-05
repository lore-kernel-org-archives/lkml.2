Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182Ab2CEBDM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 20:03:12 -0500
Received: from mail-pz0-f52.google.com ([209.85.210.52]:48661 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270Ab2CEBDJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 20:03:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of paul.gortmaker@gmail.com designates 10.68.130.193 as permitted sender) smtp.mail=paul.gortmaker@gmail.com; dkim=pass header.i=paul.gortmaker@gmail.com
MIME-Version: 1.0
In-Reply-To: <hq7dqombK_C.A.gMF.WG9UPB@chimera>
References: <FNlNbnGKWLP.A.dME.3F9UPB@chimera>
	<hq7dqombK_C.A.gMF.WG9UPB@chimera>
Date: Sun, 4 Mar 2012 20:03:09 -0500
X-Google-Sender-Auth: 2Iwq85CvcQoBJLHNClamg9NK0-M
Message-ID: <CAP=VYLqMhmtFvoB3td4E4gZ2hjOKriEgGoqChWkwtsJVZN9ZrQ@mail.gmail.com>
Subject: Re: [Bug #42713] Regression in skge that started around acb42a3 (so
 past v3.3-rc1)
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 4, 2012 at 3:31 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 3.2.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : https://bugzilla.kernel.org/show_bug.cgi?id=42713
> Subject         : Regression in skge that started around acb42a3 (so past v3.3-rc1)
> Submitter       : Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date            : 2012-01-30 15:58 (35 days old)
> Message-ID      : <20120130155816.GA1400@phenom.dumpdata.com>
> References      : http://marc.info/?l=linux-kernel&m=132793944220262&w=2

This might also be a useful reference:

https://lkml.org/lkml/2012/2/6/486

Paul.
--

>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
