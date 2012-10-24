Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422700Ab2JXWHH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 18:07:07 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:35707 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758777Ab2JXWHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 18:07:03 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH] [resend] ACPI: Fix memory leak in acpi_bind_one() (fwd)
Date: Thu, 25 Oct 2012 00:10:59 +0200
Message-ID: <112621184.6eyltZaVYS@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.6.2-6-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1210152049550.1038@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1210152049550.1038@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 15 of October 2012 20:51:11 Jesper Juhl wrote:
> Ok, so I had a little problem with my mail servers clock that caused the 
> mail below to be timestamped a few years in the past, so I assume noone 
> saw it - thus, resending.

Applied to linux-pm.git/linux-next as v3.7 material, will be included in the
next linux-pm push.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
