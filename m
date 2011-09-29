Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1I2OmJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 10:42:09 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52619 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755070Ab1I2OmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 10:42:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 19/24] C6X: headers
Date: Thu, 29 Sep 2011 16:41:21 +0200
Message-ID: <3471979.HTqjRmXnHP@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317306284.2580.119.camel@deneb.redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <201109281607.11228.arnd@arndb.de> <1317306284.2580.119.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:AENHFZ8m51FrFZWhPGxkGjvQGVyroUEm7nrC+lnQpz2
 xq7bFdqqc23hcAWp30LxP6sTT4peUd8F+aQyx6bxjm/X1fEmcF
 VfB4LWOLR+lC0BwmPHuoB7jfQi1q5npnOzBbJhwA5758tdDqE+
 6pGMHpw1QF59mKWRbSVrebBA13wpPwB1fgOoo5qZ1oKfvPOV5P
 wTElbuhhhAM0NelfJj4eIJz8dAlFpPEqxmNYLgtKZ5q1FafKaW
 uwI3g3S7caBXYjETmMtH1KnOR/UVdT0ldvhbfRmz0nIxEhkMQX
 EgzTRrAtlRWw+9/mh1whuraKzriC0o9fOgxad4yTKiNS3yMRqx
 vaYG2otsWQcBLIA1w/KU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 September 2011 10:24:43 Mark Salter wrote:
> I think we still want the c6x unaligned.h because the hardware can do
> unaligned 32 and 64 memory accesses with no performance penalty. There
> are some addressing mode limitations which is why the compiler doesn't
> use them generally.

Ok. I guess you still only need to override __cpu_to_{le,be}{16,32,64}p and
__{le,be}{16,32,64}_to_cpup then and use include/linux/unaligned/access_ok.h.

	Arnd
