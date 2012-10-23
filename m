Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934129Ab2JWXPj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:15:39 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:55199 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933615Ab2JWXPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:15:36 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210231541350.1221@chino.kir.corp.google.com>
References: <CAGPN=9Qx1JAr6CGO-JfoR2ksTJG_CLLZY_oBA_TFMzA_OSfiFg@mail.gmail.com>
	<20121022173315.7b0da762@ilfaris>
	<20121022214502.0fde3adc@ilfaris>
	<20121022170452.cc8cc629.akpm@linux-foundation.org>
	<alpine.LNX.2.00.1210222059120.1136@eggly.anvils>
	<20121023110434.021d100b@ilfaris>
	<CAJL_dMvUktOx9BqFm5jn2JbWbL_RWH412rdU+=rtDUvkuaPRUw@mail.gmail.com>
	<alpine.DEB.2.00.1210231541350.1221@chino.kir.corp.google.com>
Date: Wed, 24 Oct 2012 02:15:34 +0300
Message-ID: <CAJL_dMtS-rc1b3s9YZ+9Eapc21vF06aCT23GV8eMp13ZxURvBA@mail.gmail.com>
Subject: Re: Major performance regressions in 3.7rc1/2
From: Anca Emanuel <anca.emanuel@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: Julian Wollrath <jwollrath@web.de>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Patrik Kullman <patrik.kullman@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 1:42 AM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 23 Oct 2012, Anca Emanuel wrote:
>
>> I have the same problem.
>> Reverting
>> https://github.com/torvalds/linux/commit/957f822a0ab95e88b146638bad6209bbc315bedd
>> solves the problem for me.
>>
>
> If you don't revert anything and do
>
>         echo 0 > /proc/sys/vm/zone_reclaim_mode
>
> after boot, does this also fix the issue?

Yes.
http://imgur.com/JJwiJ
