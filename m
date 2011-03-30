Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1C3COB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:14:01 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40742 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753652Ab1C3COA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:14:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wfvyZMD+Djldu8/PdfpV/jc0J2SZuoAEStdmVpk1ntzDuFB/yXHpcbPYKQUiBqKTfp
         wu9gefSaqBeLFksXHgZB1+zzsGlCbgtYJGs2pP7qjLv9GE9jW5wDuvN0Q9spyELutGk1
         dImJTvNtXdI+hmx3FdCzq0dh1jqyf1yyRCEhg=
MIME-Version: 1.0
In-Reply-To: <1301410764.3161.156.camel@edumazet-laptop>
References: <AANLkTinthHDRYpfNrXSiOz9t_y5HyVMpjP-dLm_bn0es@mail.gmail.com>
	<1301410764.3161.156.camel@edumazet-laptop>
Date: Wed, 30 Mar 2011 10:13:58 +0800
Message-ID: <AANLkTinxKri8QEfcnBCBg7Pxh-8fk9Yf3VVVdH76_YXe@mail.gmail.com>
Subject: Re: ping when network down BUG: unable to handle kernel NULL pointer
 dereference at 000000000000001b
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 10:59 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mardi 29 mars 2011 à 22:54 +0800, Jeff Chua a écrit :
>> I don't know when this started happening as my network was always up.
>> Just down, I shutdown my network, and ping a known host and
>> encountered this BUG.
> Known problem, should be fixed by
 http://git2.kernel.org/?p=linux/kernel/git/davem/net-2.6.git;a=commit;h=4910ac6c526d2868adcb5893e0c428473de862b5

Cool. I just git pulled the commit, and it works now!

Thanks,
Jeff
