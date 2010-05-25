Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758750Ab0EYTfX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 15:35:23 -0400
Received: from mbox2.netikka.net ([213.250.81.203]:38868 "EHLO
	mbox2.netikka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758533Ab0EYTfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 15:35:22 -0400
Message-ID: <4BFC2677.7050509@mandriva.org>
Date: Tue, 25 May 2010 22:35:19 +0300
From: Thomas Backlund <tmb@mandriva.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100517 Mandriva/3.0.4-8mdv2010.1 (2010.1) Thunderbird/3.0.4
MIME-Version: 1.0
Newsgroups: gmane.linux.network,gmane.linux.kernel.wireless.general,gmane.linux.kernel
To: sedat.dilek@gmail.com
CC: Sedat Dilek <sedat.dilek@googlemail.com>,
       "John W. Linville" <linville@tuxdriver.com>, davem@davemloft.net,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2010-05-25
References: <20100525170401.GE31753@tuxdriver.com> <AANLkTilMYGSprjMnmRHlZPMvk1KLd1Yeqd_l26yyVRT6@mail.gmail.com>
In-Reply-To: <AANLkTilMYGSprjMnmRHlZPMvk1KLd1Yeqd_l26yyVRT6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

25.05.2010 22:23, Sedat Dilek skrev:
> "[1/2] iwlwifi: fix internal scan race" [1] is in this pull request.
> Isn't "[2/2] iwlagn: work around rate scaling reset delay" [2] missing?
> IIRC, both fixes were sent as a double-patch.
>

It's already upstream:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=3bce6066263efb5733ee2141ac8b56684fb3b0a7

> - Sedat -
>
> [1] https://patchwork.kernel.org/patch/99439/
> [2] https://patchwork.kernel.org/patch/99438/
>

--
Thomas
