Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755384Ab1FCS6H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 14:58:07 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:50623
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753931Ab1FCS6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 14:58:05 -0400
X-SpamScore: -6
X-BigFish: VS-6(zz1102K98dKzz1202hzzz2dh2a8h668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Message-ID: <4DE92EA2.60705@freescale.com>
Date: Fri, 3 Jun 2011 13:57:38 -0500
From: Timur Tabi <timur@freescale.com>
Organization: Freescale
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.19) Gecko/20110429 Fedora/3.6.17-1.fc13 Firefox/3.6.17
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Alexey Dobriyan <adobriyan@gmail.com>, <alan@lxorguk.ukuu.org.uk>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] lib: introduce strdup_from_user
References: <1307119552-15573-1-git-send-email-timur@freescale.com>	<BANLkTikFjF0WF---8A9_CBybf+bUji2smw@mail.gmail.com>	<4DE92675.6080908@freescale.com>	<BANLkTimB2UanZA4wf=uBGcj=wKmDhCco=w@mail.gmail.com>	<4DE9294B.3040501@freescale.com>	<BANLkTinqQS11nXQAJBMSvCrp4tOtCg5Qww@mail.gmail.com> <20110603135303.0800e4a7@schlenkerla.am.freescale.net>
In-Reply-To: <20110603135303.0800e4a7@schlenkerla.am.freescale.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Scott Wood wrote:
> Why does it matter, as long as it doesn't hurt the kernel if userspace
> plays games (i.e. take care of the NUL termination), and it's not a
> performance problem?

Ok, I don't know why I didn't notice this earlier, but this function already
exists in the kernel.  It's called strndup_user().

So I'd like to rescind this patch, please.

Note that strndup_user() has the double-access problem.

-- 
Timur Tabi
Linux kernel developer at Freescale

