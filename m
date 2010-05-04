Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab0EDQFj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 12:05:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39763 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084Ab0EDQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 12:05:37 -0400
Date: Tue, 4 May 2010 17:05:22 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Hans Ulli Kroll <ulli.kroll@googlemail.com>
Cc: paulius.zaleckas@gmail.com, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: Gemini: fix compiler error in copypage-fa.c
Message-ID: <20100504160522.GD30601@n2100.arm.linux.org.uk>
References: <1272983655-18408-1-git-send-email-ulli.kroll@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272983655-18408-1-git-send-email-ulli.kroll@googlemail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 04, 2010 at 04:34:15PM +0200, Hans Ulli Kroll wrote:
> Fix compiler error in copypage-fs.c
> missing struct vm_area_struct *vma in function
> fa_copy_user_highpage

Ok.  Please submit to the patch system, thanks.
