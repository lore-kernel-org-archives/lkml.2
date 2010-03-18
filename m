Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab0CRTMm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:12:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57578 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751181Ab0CRTMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:12:41 -0400
Date: Thu, 18 Mar 2010 12:11:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Magnus Lynch <maglyx@gmail.com>
Cc: Clemens Ladisch <clemens@ladisch.de>,
       "Venkatesh Pallipadi (Venki)" <venkatesh.pallipadi@intel.com>,
       "Vojtech Pavlik" <vojtech@suse.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hpet: factor timer allocate from open
Message-Id: <20100318121151.cedeb849.akpm@linux-foundation.org>
In-Reply-To: <4b943f17.4902be0a.5bd5.0917@mx.google.com>
References: <4B8F72B5.3000408@ladisch.de>
	<4b943f17.4902be0a.5bd5.0917@mx.google.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 07 Mar 2010 16:04:39 -0800 (PST)
Magnus Lynch <maglyx@gmail.com> wrote:

> Clemens Ladisch wrote:
> >> If so I can change that. I did add the explicit form of allocating
> >> timers to accomodate such a case hypothetically (open, allocate timer,
> >> get info).
> >
> > This wouldn't be backwards compatible.
> 
> OK, here's a version that retains HPET_INFO semantics.
> 
> Signed-off-by: Magnus Lynch <maglyx@gmail.com>

(wonders what this patch does)

Please always retain and maintain the changelog with each version of a patch.

Please resend this patch with a complete changelog.  Make sure that the
changelog addresses any questions which were raised during review. 
Please ensure that all participants in that review were cc'ed.

Thanks.
