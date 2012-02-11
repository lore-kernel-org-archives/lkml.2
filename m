Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871Ab2BKTwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:52:24 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:56179 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab2BKTwX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:52:23 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 1/4] [SCSI] ufshcd: UFS Host controller driver
Date: Sat, 11 Feb 2012 19:52:08 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: Girish K S <girish.shivananjappa@linaro.org>,
        Vinayak Holikatti <vinholikatti@gmail.com>,
        James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org,
        linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org,
        venkat@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com,
        yejin.moon@samsung.com, Sree kumar <sreekumar.c@samsung.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com> <CAGxe1ZGDy-MWetg_rki2ms1Yy0dn4WqfrJgK+wPrucojyt-fHw@mail.gmail.com> <CALMYJDtCc_M8dOna1wfeLai1Fjj3NfcnJb7AcFNgMdvGQtuamA@mail.gmail.com>
In-Reply-To: <CALMYJDtCc_M8dOna1wfeLai1Fjj3NfcnJb7AcFNgMdvGQtuamA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202111952.08745.arnd@arndb.de>
X-Provags-ID: V02:K0:sosMvhDl0D3cAqRTHJe2npKSvUlkerA6P8R2Ge0j/Bd
 VF9VEXwRL66erQ1tox6aitKoBLULIKJmJYw3WHPCN3U6grJO0A
 /oPpdit7PHkpe/hjxbGv8Dz+JKNYEyUH2HnoiBLKz8e85CLS2d
 2x3zRjyg/hmMX5WTPnNKkai1MYnqwgs6LXH/PEmMhXR/CS6hf/
 VlSMUtlPEqmJtjdyN+zw3bUHZICm4IULM/6ChlFtLtFgsjZp4R
 iQP6Zd5VKrC5hYijbrOBSAeT5zKvb7mdrUe4bWmX+nWr9A7oE3
 3FmwKBewIQgH+E9382PdobX2T07PZckDW5l9XZ6RsqQpDH4Gd+
 KTGIVaEnSsdprszSRKiM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 February 2012, Santosh Y wrote:
> > UFS host controller specification Section 7.2.1, step 11,  mentions
> > that the aggregation control register should be set if run/stop bit is
> > not enabled.
> > But In this case the run/ stop bit is set above before configuring the
> > aggregation register. Please check for the same in other places from
> > where it is called.
> >
> 
> The spec mentions, (Section 7.2.1, step 11)
> "UTRIACR initialization may be executed at any time when the Run/Stop
> register (UTRLRSR)
> is not enabled or when no requests are outstanding."
> 
> At this point in the code, during execution, there will not be any
> outstanding requests.

One meta-comment: When you reply on a long email like this, please
make sure you only quote the minimum amount of lines from the original
email to give enough context for your comment. Otherwise it becomes
much more time consuming to read your reply and readers might miss
your contribution in the middle of a long quote.

	Arnd
