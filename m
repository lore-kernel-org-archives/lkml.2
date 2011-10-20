Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab1JTNc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 09:32:57 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:58646 "EHLO linux-mips.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752733Ab1JTNc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 09:32:56 -0400
Date: Thu, 20 Oct 2011 14:32:48 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mips: fix the build with C=1
Message-ID: <20111020133248.GA20032@linux-mips.org>
References: <1319063607-11316-1-git-send-email-aaro.koskinen@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319063607-11316-1-git-send-email-aaro.koskinen@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 01:33:27AM +0300, Aaro Koskinen wrote:

> When trying to compile the 3.1-rc10 kernel for my MIPS board with C=1
> (sparse checking), the build fails early with the error:

This is triggered by builds with GCC 4.5 and newer.

Applied.  Thanks!

  Ralf
