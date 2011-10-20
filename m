Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298Ab1JTI7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:59:03 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37268 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782Ab1JTI7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:59:01 -0400
Date: Thu, 20 Oct 2011 12:58:55 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, a.p.zijlstra@chello.nl,
        paulus@samba.org, mingo@elte.hu, acme@ghostprotocols.net,
        anton@samba.org, daahern@cisco.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools/perf: Increase symbol KSYM_NAME_LEN size
Message-ID: <20111020085855.GE14464@moon>
References: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
 <CAOJsxLGZLx-Wybi=BM41pN5X5Xw=qw4dEC_q=Qy903GpKj6Nzw@mail.gmail.com>
 <20111020081451.GC14464@moon>
 <CAPybu_3kqqtfv1XyhruS3AMiRbd=wdMUr4rJL1UmDG_+z2m9jA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPybu_3kqqtfv1XyhruS3AMiRbd=wdMUr4rJL1UmDG_+z2m9jA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 10:45:01AM +0200, Ricardo Ribalda Delgado wrote:
> That is 4gb size :S..... I have tried making a dummy program
> 
> int tttttt......ttttt (int a, int b){
> return a+b;
> }
> 
> int main(int arg, char *[]argv){
>     return tttt....tttt(1,2);
> }
> 
> and it has worked at least until t^16384 both in gcc and in gdb, and I
> guess it would have continue working until much more.
> 
> Right now, I think we can increase it until 512, to be on the safe
> side, and keep it simple. What do you think?
> 

I've no idea how perf uses them, so I think I have no rights to
advise here ;) If this has no performance impact then sure, looks
good.

	Cyrill
