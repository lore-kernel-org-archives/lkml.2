Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755702Ab1KUXed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 18:34:33 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60733 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752400Ab1KUXec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 18:34:32 -0500
Message-ID: <4ECADFE9.9030705@gmail.com>
Date: Tue, 22 Nov 2011 03:34:01 +0400
From: Alexey Moiseytsev <himeraster@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111110 Icedove/3.0.11
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [bug] af_unix: Reading from a stream socket may lock the concurrent
 poll() call
References: <CAHjqzy7dhqi22yPJX=DP4x916hVXDY2WaDbdmnTEQ54n6qpMXw@mail.gmail.com> <20111120.153156.1383147368726575639.davem@davemloft.net>
In-Reply-To: <20111120.153156.1383147368726575639.davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

21.11.2011 00:31, David Miller пишет:
> From: Alexey Moiseytsev<himeraster@gmail.com>
> Date: Mon, 21 Nov 2011 00:19:02 +0400
>
>> Other info:
>> $ uname -srmo
>> Linux 2.6.32-5-amd64 x86_64 GNU/Linux
>
> There have been numerous AF_UNIX bug fixes since that release, please try
> to reproduce your problem with current kernels.
>

I upgraded kernel up to 3.2-rc2 but the problem still exists.
