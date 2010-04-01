Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab0DAUMU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 16:12:20 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43224 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316Ab0DAUMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 16:12:15 -0400
Date: Thu, 1 Apr 2010 13:12:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: <nick.cheng@areca.com.tw>
Cc: <linux-scsi@vger.kernel.org>, <James.Bottomley@HansenPartnership.com>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SCSI: improve arcmsr's error handlers on lk2.6.33
Message-Id: <20100401131209.7e98e169.akpm@linux-foundation.org>
In-Reply-To: <5218DF384A2B48489336901AC84E6C09@areca4e4f859d4>
References: <5218DF384A2B48489336901AC84E6C09@areca4e4f859d4>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Mar 2010 12:39:21 +0800
"Nick Cheng" <nick.cheng@areca.com.tw> wrote:

> This is to principally improve arcmsr's error handlers, eh_bus_reset_handler
> and eh_abort_handler.

The patch is horridly wordwrapped.  Please fix your email client and resend.

Also, that's a large amount of code and a very small description.  It
would help if you were to explain each of the changes, and the
reasoning behind them.

Ideally this patch would have been presented as a series of patches,
one-concept-per-patch.  A single rolled-up patch is OK I guess, but
providing us with sufficient information to understand all the changes
makes things a lot easier.

Thanks.
