Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752945Ab2I0QEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 12:04:42 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:47413 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab2I0QEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 12:04:41 -0400
Message-ID: <5064790E.4000207@cs.tu-berlin.de>
Date: Thu, 27 Sep 2012 18:04:30 +0200
From: =?UTF-8?B?IkphbiBILiBTY2jDtm5oZXJyIg==?= <schnhrr@cs.tu-berlin.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120919 Thunderbird/10.0.7
MIME-Version: 1.0
To: Kay Sievers <kay@vrfy.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
References: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de> <20120926211526.GA30261@kroah.com> <506382B0.8040908@cs.tu-berlin.de> <CAPXgP11xwBDSZ9q9thzbXd5xZW_jeq-OW96hSoXFbXQBjQWbqw@mail.gmail.com> <506474D0.9020406@cs.tu-berlin.de>
In-Reply-To: <506474D0.9020406@cs.tu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2012 17:46, schrieb "Jan H. Schönherr":
> If we say "if LOG_CONT is set, this message continues the previous one",
> we can also say "there is no prefix on this message". Then on the other
> hand, we would need a "whatever comes next, it does not continue this
> message"....

Thinking a bit longer about this one.

If really, really everything passes through vprintk_emit()
then we could keep all info about the previous message
there and definitely decide whether the current message continues
the previous one.

Then, we wouldn't need to track the previous flags everywhere.

Do I miss something?

Regards
Jan
