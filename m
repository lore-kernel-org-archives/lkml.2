Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759857Ab2J2Qhg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:37:36 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42130 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756804Ab2J2Qhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:37:34 -0400
MIME-Version: 1.0
In-Reply-To: <1351521658.13356.7.camel@deadeye.wl.decadent.org.uk>
References: <508E002B.4090200@teksavvy.com>
	<20121029064643.GE574@1wt.eu>
	<508E913D.2080104@teksavvy.com>
	<1351521658.13356.7.camel@deadeye.wl.decadent.org.uk>
Date: Mon, 29 Oct 2012 09:37:32 -0700
X-Google-Sender-Auth: DKM_uJe01e3X5GkvHYSPZMPXXPA
Message-ID: <CAE9FiQXHgLyCUGdFbbzYmXsX8uqpsAwXCt=j6ZD8RG=g7kRnfA@mail.gmail.com>
Subject: Re: Regression from 3.4.9 to 3.4.16 "stable" kernel
From: Yinghai Lu <yinghai@kernel.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Mark Lord <kernel@teksavvy.com>, Willy Tarreau <w@1wt.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 29, 2012 at 7:40 AM, Ben Hutchings <ben@decadent.org.uk> wrote:
> However I'm not sure that this loop is correct either.  Yinghai, does
> your version definitely iterate in increasing pfn order?  If not then
> the max_pfn_mapped assignment must be conditional.

yes, memblock is in order.

Yinghai
