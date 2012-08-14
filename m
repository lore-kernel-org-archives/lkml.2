Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532Ab2HNJPp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 05:15:45 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:43006 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2HNJPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 05:15:43 -0400
MIME-Version: 1.0
In-Reply-To: <502A11A0.7070906@nvidia.com>
References: <CAH+eYFAJ0FSiZoDiyYJsEg1j-cAhG7DkCwFNJGe5vBNpiUM7ug@mail.gmail.com>
 <502A11A0.7070906@nvidia.com>
From: Rabin Vincent <rabin@rab.in>
Date: Tue, 14 Aug 2012 11:15:03 +0200
X-Google-Sender-Auth: ynOWZcJP4n4XOdMkX1Px2SMEQzw
Message-ID: <CAH+eYFAu7kM7TSTd=WeoXz_NSUWGY5EmFwcb7a-p1kh_Lxrifw@mail.gmail.com>
Subject: Re: "regulator: Enable supply regulator if child rail is enabled" broken?
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "lrg@ti.com" <lrg@ti.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/14 Laxman Dewangan <ldewangan@nvidia.com>:
> Yaah, It is missing the regulator_disable() in regulator_init_complete() for
> some cases.
> Please let me know if I need to send patch for fixing this issue.

Yes, please do.
