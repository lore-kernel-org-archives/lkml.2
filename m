Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2JPRCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 13:02:44 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:57027 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2JPRCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 13:02:42 -0400
Message-ID: <507D9069.7090804@linux.vnet.ibm.com>
Date: Tue, 16 Oct 2012 11:50:49 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
CC: Robert Jennings <rcj@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Johannes Stezenbach <js@sig21.net>,
        Richard Weinberger <richard.weinberger@gmail.com>
Subject: Re: [PATCH 0/3] Update LZO compression
References: <507C61B2.9060503@linux.vnet.ibm.com> <507CA000.5040905@oberhumer.com>
In-Reply-To: <507CA000.5040905@oberhumer.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12101616-5518-0000-0000-0000087C4037
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2012 06:45 PM, Markus F.X.J. Oberhumer wrote:
> The crypto LZO test vectors had to be updated - this should land in linux-next
> soon (or you can just pull from my branch).

Thanks, I pulled from your branch and now it works fine.

I noticed that you made the test vectors longer.  Any particular
reason? Is there a new minimum length now or something?

I guess I'm not understanding why a change to the test vectors was needed.

Seth

