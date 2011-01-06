Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1AGOJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 09:09:55 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:52321 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1AGOJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 09:09:54 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <richardcochran@gmail.com>
Subject: Re: [PATCH V8 01/13] time: Introduce timekeeping_inject_offset
Date: Thu, 6 Jan 2011 23:00:17 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        John Stultz <johnstul@us.ibm.com>, Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
References: <cover.1293820862.git.richard.cochran@omicron.at> <15a12892b0bfc17327d2b3a7695c81fbe6f34337.1293820862.git.richard.cochran@omicron.at>
In-Reply-To: <15a12892b0bfc17327d2b3a7695c81fbe6f34337.1293820862.git.richard.cochran@omicron.at>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101062300.17289.arnd@arndb.de>
X-Provags-ID: V02:K0:ZKmyyIAHcuK51ftAj4vWJEm8Bf+3R1ZKdAN3r+2eIRx
 ulyA7yvZkUZOYLvx/GziXe8v373fknWcOh6Hc8jAh+RgrnDv2Y
 FO/0fkrVheX8jORr0oRSw5A/g0rmBHcfwpzeUS0wzbrhQRPEKE
 lB/LkR4nhoBlX2eAwlUnKajgHkW+ijPhFK9YJegaVQQmIvlhJM
 myt5QKhJwM40W2NbdwLQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 31 December 2010, John Stultz <richardcochran@gmail.com> wrote:
> This adds a kernel-internal timekeeping interface to add or subtract

Note that this is not the correct way to submit a patch from someone else.
You should instead use your own name and email address as the sender,
and have "From: John Stultz <johnstul@us.ibm.com>" as the first line in
the body of the email. You also need to add your own "Signed-off-by: 
Richard Cochran <richardcochran@gmail.com>" line below the S-o-b from
John.

Using git-send-email plus git-format-patch will gets this right if
the commit was done correctly in your own git tree. If you prefer to
use a different set of tools, you need to watch out for these details
yourself.

	Arnd

