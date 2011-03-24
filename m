Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab1CXCYb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 22:24:31 -0400
Received: from fifo99.com ([67.223.236.141]:35253 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752743Ab1CXCYa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 22:24:30 -0400
Subject: Re: [PATCH] msm: Add gpio support for 8960
From: Daniel Walker <dwalker@fifo99.com>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: davidb@codeaurora.org, bryanh@codeaurora.org, linux@arm.linux.org.uk,
        dima@android.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
In-Reply-To: <4D8A88AE.2000701@codeaurora.org>
References: <1300402640-23995-1-git-send-email-rvaswani@codeaurora.org>
	 <1300885151.6117.11.camel@m0nster>  <4D8A88AE.2000701@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 19:24:27 -0700
Message-ID: <1300933467.6117.49.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-23 at 16:56 -0700, Rohit Vaswani wrote:
> >>
> >> -	set_irq_chained_handler(TLMM_SCSS_SUMMARY_IRQ,
> >> +	set_irq_chained_handler(TLMM_MSM_SUMMARY_IRQ,
> >>   				msm_summary_irq_handler);
> > Ok, so looks like a rename. Can you add this to the commit text along
> > with descriptions of everything else your doing?
> Daniel,
> Adding support for 8960 includes making sure that Gpio support remains 
> meaningful and at the same time uniform across different boards. Should 
> we enumerate the specific changes ?

Should let everyone know exactly what your doing, even breaking up the
changes into specific patches.

Daniel

