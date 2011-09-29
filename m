Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab1I2NTm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 09:19:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52941 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752408Ab1I2NTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 09:19:40 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Salter <msalter@redhat.com>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 00/24] C6X: New architecture
Date: Thu, 29 Sep 2011 15:18:52 +0200
Message-ID: <1480119.xupFVdlN5c@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <1317301332.2580.108.camel@deneb.redhat.com>
References: <1317155405-26235-1-git-send-email-msalter@redhat.com> <60327.1317300157@turing-police.cc.vt.edu> <1317301332.2580.108.camel@deneb.redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S0Tv4nIR6qhp77xDhIjhbehP8I3t04JXj6ROSHdznnb
 mqKRp0DAKOSeTNsRHjl1nxy6iLsN7BtiIScxCqeEB//ngZ4rMw
 +H4Kew5GPazrqxcBbuq4rAjkvWt+EMUP6ck3g3UiR/wZDf+dws
 dvRcT3PXjNZl4JzA+NOwIcWA0viLNIgIGW7c3ocAVwP/SmR3Yu
 nhFTIEXawgaG+IQzlHjJlodWAlN98OjBb0pURlVsHuUevBUxn7
 ke4PnroNaHHuuhgu/jmfbpM5kssFoj2hImm3tYG7jgMtkaVQF4
 boL88IyYB8Lzxe74kKBMsKEMitg/dCxb/5ry0eK4ju9bH5I7cJ
 O/ojrhr+Ror7+K2r6rPw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 29 September 2011 09:02:11 Mark Salter wrote:
> 
> Other models are also possible. For instance, other cores could run
> dedicated DSP applications using some other minimal OS with HW supported
> communication with the Linux OS acting as the overall manager.

Yes, that makes a lot of sense. I guess if you ever want to turn c6x
into something more capable, adding an MMU would be higher on the
priority list than proper SMP, which requires both cache coherency
and atomic operations.

	Arnd
