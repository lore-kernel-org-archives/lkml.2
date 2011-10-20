Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143Ab1JTJOI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 05:14:08 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46351 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab1JTJOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 05:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_3kqqtfv1XyhruS3AMiRbd=wdMUr4rJL1UmDG_+z2m9jA@mail.gmail.com>
References: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
	<CAOJsxLGZLx-Wybi=BM41pN5X5Xw=qw4dEC_q=Qy903GpKj6Nzw@mail.gmail.com>
	<20111020081451.GC14464@moon>
	<CAPybu_3kqqtfv1XyhruS3AMiRbd=wdMUr4rJL1UmDG_+z2m9jA@mail.gmail.com>
Date: Thu, 20 Oct 2011 12:14:06 +0300
X-Google-Sender-Auth: P9WgWXU8hm-JlmQcjKudRVSquKM
Message-ID: <CAOJsxLEY2YJv5G7nRKzM4UowVpPQrXKzmzP6eVShaXFYDySZ2A@mail.gmail.com>
Subject: Re: [PATCH] tools/perf: Increase symbol KSYM_NAME_LEN size
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@elte.hu, acme@ghostprotocols.net,
        anton@samba.org, daahern@cisco.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:45 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> That is 4gb size :S..... I have tried making a dummy program
>
> int tttttt......ttttt (int a, int b){
> return a+b;
> }
>
> int main(int arg, char *[]argv){
>    return tttt....tttt(1,2);
> }
>
> and it has worked at least until t^16384 both in gcc and in gdb, and I
> guess it would have continue working until much more.
>
> Right now, I think we can increase it until 512, to be on the safe
> side, and keep it simple. What do you think?

If the limit is really 4G, I'm fine with whatever is the smallest
practical size. If 256 bytes works for you:

Acked-by: Pekka Enberg <penberg@kernel.org>
