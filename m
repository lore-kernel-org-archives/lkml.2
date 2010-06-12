Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679Ab0FLAWk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 20:22:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36378 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751785Ab0FLAWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 20:22:38 -0400
Date: Fri, 11 Jun 2010 17:22:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Message-Id: <20100611172235.a32b91ec.akpm@linux-foundation.org>
In-Reply-To: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jun 2010 16:40:13 -0700
akpm@linux-foundation.org wrote:

> The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
> 
>    http://userweb.kernel.org/~akpm/mmotm/
> 
> and will soon be available at
> 
>    git://zen-kernel.org/kernel/mmotm.git

This oopses for me in get_ksymbol() (a linux-next bug).  I didn't have
time to find out why.  But presumably it isn't oopsing for other
linux-next testers.

