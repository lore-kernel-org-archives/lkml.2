Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0DMTnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 15:43:25 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34941 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071Ab0DMTnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 15:43:24 -0400
Date: Tue, 13 Apr 2010 12:42:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add USHRT_MAX, SHRT_MAX, SHRT_MIN
Message-Id: <20100413124252.40d6bc32.akpm@linux-foundation.org>
In-Reply-To: <20100413215206.GA17131@x200>
References: <20100413215206.GA17131@x200>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010 00:52:06 +0300
Alexey Dobriyan <adobriyan@gmail.com> wrote:

> Subject: [PATCH] Add USHRT_MAX, SHRT_MAX, SHRT_MIN

The title only half-describes the patch and had me in a panic.  I
rewrote it to

	kernel-wide: replace USHORT_MAX, SHORT_MAX and SHORT_MIN with USHRT_MAX, SHRT_MAX and SHRT_MIN

