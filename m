Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100Ab0KTMdQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 07:33:16 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45331 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752554Ab0KTMdP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 07:33:15 -0500
Subject: Re: [PATCH 5/5] sched: use the old min_vruntime when normalizing
 on dequeue
From: Peter Zijlstra <peterz@infradead.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Dima Zavin <dima@android.com>,
        Ingo Molnar <mingo@elte.hu>,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
In-Reply-To: <1290250511.2118.7.camel@laptop>
References: <1290218934-8544-1-git-send-email-john.stultz@linaro.org>
	 <1290218934-8544-6-git-send-email-john.stultz@linaro.org>
	 <1290250511.2118.7.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sat, 20 Nov 2010 13:33:30 +0100
Message-ID: <1290256410.2124.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-20 at 11:55 +0100, Peter Zijlstra wrote:
> Right, so assuming the reasoning is right (my brain still needs to wake
> up) the patch is weird, by not simply move the code bock up and avoid
> the whole extra variable like so?

Also, clearly that comments needs addressing..
