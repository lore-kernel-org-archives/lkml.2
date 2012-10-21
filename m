Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2JUMAP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 08:00:15 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62488 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796Ab2JUMAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 08:00:13 -0400
Date: Sun, 21 Oct 2012 14:00:04 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: caiyuqing <yuqingcaik@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: question about context switch on arm Linux
Message-ID: <20121021120003.GA8689@netboy.at.omicron.at>
References: <50839002.8020305@gmail.com>
 <20121021074434.GB4735@netboy.at.omicron.at>
 <5083B026.1030307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5083B026.1030307@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 21, 2012 at 04:19:50PM +0800, caiyuqing wrote:
> Richard, thanks for your reply.
> mainline Linux doesn't support FCSE, if so, when kernel switch a
> process to another(these two process share the same virtual memory
> space), that means the vitrual-to-physical address should be
> remaped, TLB shuold be invalid, CACHE should be flushed, right?

Yes, and that is why you can measure quite a long context switching
time when running Linux on ARMv4/5.

Thanks,
Richard
