Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752293Ab0DXHoq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Apr 2010 03:44:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:36620 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab0DXHoo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Apr 2010 03:44:44 -0400
Message-ID: <4BD2A11D.7040507@kernel.org>
Date: Sat, 24 Apr 2010 09:43:25 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
       Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 7/9] PM: Add suspend blocking work.
References: <1271984938-13920-1-git-send-email-arve@android.com>	 <1271984938-13920-4-git-send-email-arve@android.com>	 <1271984938-13920-5-git-send-email-arve@android.com>	 <1271984938-13920-6-git-send-email-arve@android.com>	 <1271984938-13920-7-git-send-email-arve@android.com>	 <1271984938-13920-8-git-send-email-arve@android.com>	 <4BD1576E.5070401@kernel.org> <20100423122032.GA23544@redhat.com>	 <y2ud6200be21004231549q8e52c9c0z441d82b5a15e177d@mail.gmail.com>	 <4BD290CC.4080601@kernel.org> <r2zd6200be21004240021sfaec0f3ft8a1ea7c1b12ea52a@mail.gmail.com>
In-Reply-To: <r2zd6200be21004240021sfaec0f3ft8a1ea7c1b12ea52a@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 24 Apr 2010 07:43:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 04/24/2010 09:21 AM, Arve Hjønnevåg wrote:
> OK, I'll try to do this. Do you want it in a separate header file as well?

I think it would fit better with the rest of suspend_blocker.h APIs
but it's not like I thought about it hard and long, so please take my
preference with a grain of salt.

> I only touch the work structure after the callback has returned for
> suspend blocking work, which does not allow that.

Oh, you're right.  I missed the current_work_blocks_suspend test.
Sorry about that.

Thanks.

-- 
tejun
