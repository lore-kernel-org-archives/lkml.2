Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab1LHVJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:09:55 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:34494 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1LHVJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:09:51 -0500
MIME-Version: 1.0
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3@inbmail01.lsi.com>
References: <7863850E8C98C748980632D9D3B7C19911968B8AE5@inbmail02.lsi.com>
	<A6888A6805518E4EA4AF7072A28264A604726F2824@inbmail02.lsi.com>
	<CAE9FiQWY-jhtbCmdfBY1zg_d0nreTHbkVe3CmaPQMgojDAtLaw@mail.gmail.com>
	<CAE9FiQXbu-O2exdhjziWCdiWWGNb8q7_RoECeKC5K80DEOobbw@mail.gmail.com>
	<B2FD678A64EAAD45B089B123FDFC3ED70D912FF83D@inbmail01.lsi.com>
	<B2FD678A64EAAD45B089B123FDFC3ED70D912FF8E3@inbmail01.lsi.com>
Date: Thu, 8 Dec 2011 13:09:50 -0800
X-Google-Sender-Auth: Nis6_UULUl7s2bO9BmH8Wbpxv7U
Message-ID: <CAE9FiQUBkjfOYrjxAVxG7F3GF11trkOnf0ZoKS4h5Db2gQJvbA@mail.gmail.com>
Subject: Re: mpt2sas regression: can not add disk...
From: Yinghai Lu <yinghai@kernel.org>
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-scsi-owner@vger.kernel.org" <linux-scsi-owner@vger.kernel.org>,
        James Bottomley <jejb@kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 8, 2011 at 5:30 AM, Desai, Kashyap <Kashyap.Desai@lsi.com> wrote:
> Yinghai,
>
> Please try attached patch. This must be on top of latest upstream code.
> When we have introduced fast load, scan of devices are happening from thread context.
>
> But currently we have not removed " _scsih_probe_devices(ioc);" call from actual probe and it is getting called from multiple places.
> As a result, we end-up into this issue.
>
> Please try the attached patch and provide your feedback. Based upon your result, we will post this patch to upstream.

Yes.  The attaced patch fix the problem. the disk that is attached to
the mpt2sas card is showing up in OS.

Thanks

Yinghai Lu
