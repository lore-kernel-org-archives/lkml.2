Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab1HHSTM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:19:12 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49750 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534Ab1HHSTK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:19:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAC5umyiUY3xSbpnd2z79JG-vi8voFMvCc=qeiJrDKiq869QmyQ@mail.gmail.com>
References: <1312195957-12223-1-git-send-email-per.forlin@linaro.org>
	<1312195957-12223-2-git-send-email-per.forlin@linaro.org>
	<CAC5umyiUY3xSbpnd2z79JG-vi8voFMvCc=qeiJrDKiq869QmyQ@mail.gmail.com>
Date: Mon, 8 Aug 2011 20:19:10 +0200
Message-ID: <CAJ0pr19Wx-d6wVD9UX+kzHkREeJg0yNNc8wABLYD6G-P0xFXSA@mail.gmail.com>
Subject: Re: [PATCH -mmotm 1/2] fault-injection: improve naming of public
 function should_fail()
From: Per Forlin <per.forlin@linaro.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jens Axboe <axboe@kernel.dk>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 August 2011 18:16, Akinobu Mita <akinobu.mita@gmail.com> wrote:
> 2011/8/1 Per Forlin <per.forlin@linaro.org>:
>> rename fault injection function should_fail() to fault_should_fail()
>
> fault_should_fail sounds tautological.
> fault_should_inject() is better, but I'm not sure.
> Should we retain the naming issue and go forward to merge mmc fault
> injection first?
>
Fine with me.
I'll go ahead and prepare the mmc failt-injection patches based on
current naming.

Thanks,
Per
