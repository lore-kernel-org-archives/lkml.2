Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751564Ab1HKS2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:28:03 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51001 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750741Ab1HKS2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:28:02 -0400
MIME-Version: 1.0
In-Reply-To: <20110811171812.GA17346@albatros>
References: <20110808150204.GA4252@albatros> <20110809121632.18aef937@notabene.brown>
 <20110811171812.GA17346@albatros>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 11 Aug 2011 11:27:39 -0700
Message-ID: <CA+55aFwJtyzcEksV9wDyH1vc1Mxhmkccvj_b-To-5JVWA8-qvA@mail.gmail.com>
Subject: Re: [kernel-hardening] Re: [PATCH v3 -resend] move RLIMIT_NPROC check
 from set_user() to do_execve_common()
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>,
        James Morris <jmorris@namei.org>, kernel-hardening@lists.openwall.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 10:18 AM, Vasiliy Kulikov <segoon@openwall.com> wrote:
>
> It got 2 positive feedbacks and seems nobody has better solution.
> Is it possible to see it in 3.1?

Yup. Applied. Thanks for keeping at it,

                      Linus
