Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456Ab1I2Kdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:33:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53767 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750870Ab1I2Kdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:33:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Valdis.Kletnieks@vt.edu
Subject: Re: [PATCH v3 00/24] C6X: New architecture
Date: Thu, 29 Sep 2011 12:33:24 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Mark Salter <msalter@redhat.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <22021.1317246541@turing-police.cc.vt.edu>
In-Reply-To: <22021.1317246541@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109291233.24623.arnd@arndb.de>
X-Provags-ID: V02:K0:yRYGXDBt+YU+XicWZ55fWlbqP4WHk3sM6wkYmQiglBC
 LR3x0qU6OgmDCI9Yo8CGhXMvzaGKgxRyXHA6AkH3laA/fGlBT/
 N8jkl3TRpvW/pf4H1WnbmnpDkiSwUw8IN1u7/divXJ5x+79fqq
 ZFnxZN6iuVs1mTR4DnZab9WTe/qdapbQ6T6O+N1kgZHXDjYULw
 Xy9ZQMVqOsyHeBttTGZznV5P46YMmirJISu9c/eHSyjjcxj59/
 3E7dsC3qYy8lFu3kI+5/31siER2zMgrI1LZmweAueLBGDuiXjL
 B81FH5G6Omte47z2dnLix2J402H5wtZTiexx6BGtJyKK+Z+qrz
 a2ihPPvQyFOSFvoGSdfA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 28 September 2011, Valdis.Kletnieks@vt.edu wrote:
>   Show Details
>   On Tue, 27 Sep 2011 16:29:41 EDT, Mark Salter said:
> 
> > This architecture supports members of the Texas Instruments family
> > of C6x single and multicore DSPs. The multicore DSPs do not support
> > cache coherancy, so are not suitable for SMP.
> 
> Is there a usage model for the multicore? I know somebody had some patches for
> "HPC dedicated compute cores" that would just basically run a userspace process
> and that's it - would those be applicable here?

No, that's a different thing. Even with dedicated compute cores, you need
cache coherency.

	Arnd
