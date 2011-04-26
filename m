Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932641Ab1DZVXH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:23:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49425 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932448Ab1DZVXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:23:02 -0400
Date: Tue, 26 Apr 2011 14:22:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
Cc: Paul Gortmaker <p_gortmaker@yahoo.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv1 -next] RTC: RTC module of DA9052 PMIC driver
Message-Id: <20110426142210.a21ebc45.akpm@linux-foundation.org>
In-Reply-To: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B89B2B2@KCINPUNHJCMS01.kpit.com>
References: <E2CAE7F7B064EA49B5CE7EE9A4BB167D151B89B2B2@KCINPUNHJCMS01.kpit.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Apr 2011 17:52:31 +0530
Ashish Jangam <Ashish.Jangam@kpitcummins.com> wrote:

> From: Ashish Jangam <Ashish.Jangam@kpitcummins.com>
>
> ...
> 
> RTC Driver for Dialog Semiconductor DA9052 PMICs.
> 
> Changes made since last submission:
> . removed duplicate function name from rtc_err
> 
> Signed-off-by: D. Chen <dchen@diasemi.com>

We have some attribution problems here.

The driver appears to have been written by dchen, but because the
changelog didn't have his From: line at the top, you've implied that
you were the author.  Please clarify this.

Also, the patch should include your Signed-off-by: line, as you were on
the delivery path.  Please see Documentation/SubmittingPatches for a
discussion of this, then send us your Signed-off-by:.

