Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab2B0HaB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:30:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40086 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab2B0H37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:29:59 -0500
Date: Sun, 26 Feb 2012 23:31:11 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Steven Truelove <steven.truelove@utoronto.ca>
Cc: wli@holomorphy.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Round up huge page count to avoid allocating too little
 memory when 'size' argument is not a multiple of the huge page size.
Message-Id: <20120226233111.d54339fe.akpm@linux-foundation.org>
In-Reply-To: <1328804163-24134-1-git-send-email-steven.truelove@utoronto.ca>
References: <1328804163-24134-1-git-send-email-steven.truelove@utoronto.ca>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 Feb 2012 11:16:03 -0500 Steven Truelove <steven.truelove@utoronto.ca> wrote:

> Signed-off-by: Steven Truelove <steven.truelove@utoronto.ca>

Please don't send unchangelogged patches.

What is missing here is any explanation of why we should make this
change.  Is there some kernel bug you have observed?  If so, please
describe it.
