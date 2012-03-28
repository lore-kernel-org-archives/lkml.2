Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756119Ab2C1Ltv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 07:49:51 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36876 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497Ab2C1Ltu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 07:49:50 -0400
Date: Wed, 28 Mar 2012 13:49:45 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86, amd: Be more verbose about LVT offset assignments
Message-ID: <20120328114944.GB17936@gmail.com>
References: <1332876615-29219-1-git-send-email-robert.richter@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332876615-29219-1-git-send-email-robert.richter@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Richter <robert.richter@amd.com> wrote:

> Add information about LVT offset assignments to better debug 
> firmware bug messages related to this.

Which particular bug message(s) is this related to, can you 
quote an example perhaps?

Thanks,

	Ingo
