Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753362Ab1HHQQW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 12:16:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62845 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab1HHQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 12:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <1312195957-12223-2-git-send-email-per.forlin@linaro.org>
References: <1312195957-12223-1-git-send-email-per.forlin@linaro.org>
	<1312195957-12223-2-git-send-email-per.forlin@linaro.org>
Date: Tue, 9 Aug 2011 01:16:20 +0900
Message-ID: <CAC5umyiUY3xSbpnd2z79JG-vi8voFMvCc=qeiJrDKiq869QmyQ@mail.gmail.com>
Subject: Re: [PATCH -mmotm 1/2] fault-injection: improve naming of public
 function should_fail()
From: Akinobu Mita <akinobu.mita@gmail.com>
To: Per Forlin <per.forlin@linaro.org>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/1 Per Forlin <per.forlin@linaro.org>:
> rename fault injection function should_fail() to fault_should_fail()

fault_should_fail sounds tautological.
fault_should_inject() is better, but I'm not sure.
Should we retain the naming issue and go forward to merge mmc fault
injection first?
