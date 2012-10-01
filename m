Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2JAKrJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 06:47:09 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:54413 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160Ab2JAKrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 06:47:07 -0400
Date: Mon, 1 Oct 2012 06:46:52 -0400
From: Jamie Gloudon <jamie.gloudon@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: hughd@google.com
Subject: Re: x86_64: wrong DirectMap kB
Message-ID: <20121001104652.GA1390@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/ (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

 Interesting. I am able to reproduce the same problem as you using mem=700M, which shows: 

DirectMap4k:        4096 kB
DirectMap2M:    18446744073709547520 kB

However, it appears to be normal without the boot parameter:

DirectMap4k:        4096 kB
DirectMap2M:    15708160 kB

What does your output looks like with the full amount on 3.6?

Jamie Gloudon
