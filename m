Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab0JFEWh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:22:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50047 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752733Ab0JFEWg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:22:36 -0400
Message-ID: <4CABF91E.5000103@zytor.com>
Date: Tue, 05 Oct 2010 21:20:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] access_error API cleanup
References: <1286265215-9025-1-git-send-email-walken@google.com>	<1286265215-9025-4-git-send-email-walken@google.com>	<4CABF4F3.7050002@zytor.com>	<AANLkTi=+0i13JF552P7dF_JD+S10Lt8=+KySHdtg-Uex@mail.gmail.com> <20101005211835.070a5096.akpm@linux-foundation.org>
In-Reply-To: <20101005211835.070a5096.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/05/2010 09:18 PM, Andrew Morton wrote:
> On Tue, 5 Oct 2010 21:14:12 -0700 Michel Lespinasse <walken@google.com> wrote:
> 
>> I figure barring any surprises, the series is likely to merge from -mm
>> tree to mainline in time for 2.6.37 ?
> 
> yep.

Sounds good to me.

Again, Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

