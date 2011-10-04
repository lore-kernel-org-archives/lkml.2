Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933224Ab1JDTMu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 15:12:50 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:59017 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932539Ab1JDTMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 15:12:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Aurelien Jacquiot <a-jacquiot@ti.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v4 12/24] C6X: interrupt handling
Date: Tue, 04 Oct 2011 21:12:44 +0200
Message-ID: <6800549.cQIjGl3GgH@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317746641-26725-13-git-send-email-msalter@redhat.com>
References: <1317746641-26725-1-git-send-email-msalter@redhat.com> <1317746641-26725-13-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:xKh8Mb9bRipJevM2iHsCcW+TNZy+kYO25L9pXtsbnmw
 OXA3UrmbdqDANgC/c0cB4vvAv2ZT8PJVt/g1O7CbafZxr/ewQB
 x08JKlvrFDGG6zlCkmrljg0GoF2zj84fRZhwLafv0+yojX4EyT
 UnIbKGx9MlEAQlBXc/jOB3vJbfiyy/cyJOGJt8N0Of1C5DS5tq
 FAFeAKFzyiiMUwwryOea51fbUoqSNEDkYJ0hetasrIWzoiaDMT
 G6qUbiJh9+4pU2VedTcNbh46xkT+nvwhLW/UpUHOtc1xkPR7mH
 JfaF4IM2A+C3OsD/gBCMyAAms2pdzbaZeNBFQW+reF+xD0LdgY
 SCCXgDAqzglj/xjmAY0Y=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 October 2011 12:43:49 Mark Salter wrote:
> From: Aurelien Jacquiot <a-jacquiot@ti.com>
> 
> Original port to early 2.6 kernel using TI COFF toolchain.
> Brought up to date by Mark Salter <msalter@redhat.com>
> 
> Signed-off-by: Aurelien Jacquiot <a-jacquiot@ti.com>
> Signed-off-by: Mark Salter <msalter@redhat.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Arnd Bergmann <arnd@arndb.de>
