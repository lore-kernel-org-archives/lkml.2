Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab2DVEwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 00:52:11 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:38404 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab2DVEwJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 00:52:09 -0400
MIME-Version: 1.0
In-Reply-To: <20120422040715.GA30689@elliptictech.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
 <20120422040715.GA30689@elliptictech.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 21 Apr 2012 21:51:46 -0700
X-Google-Sender-Auth: uiPmrbqkeJg7ic2Igg8w1yh4qUI
Message-ID: <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
Subject: Re: Linux 3.4-rc4
To: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Bowler <nbowler@elliptictech.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David & co, any ideas?

There are other reports of problems with 3.3.x kernels, there's a
report from Tim <timliette@woh.rr.com> which may be related (also
apparently working in 3.2, broken black screen in all 3.3.x).

Nick, I realize you had trouble with a bisection already, but it might
really be worth trying again. Do a

    git bisect visualize

and try to pick a good commit (avoding the problems you hit) when you
hit a problem, and then do

   git reset --hard <that-point>

to force bisection to try another place. That way you can sometimes
avoid the problem spots, and continue the bisection.

                        Linus

On Sat, Apr 21, 2012 at 9:07 PM, Nick Bowler <nbowler@elliptictech.com> wrote:
> On 2012-04-21 15:43 -0700, Linus Torvalds wrote:
>> But none of it really looks all that scary. It looks like the 3.4
>> release is all on track, but please do holler if you see regressions.
>
> OK, I'll holler.  Nouveau is still broken in mainline, as it has been
> since March or so, first reported here:
>
>  Subject: Regression: black screen on VGA w/ nouveau in Linux 3.3.
>  http://thread.gmane.org/gmane.linux.kernel/1269631
>
> So far, attempts to elicit a response of any kind from maintainers has
> been about as successful as talking to my doorknob.
>
> Thanks,
> --
> Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
>
