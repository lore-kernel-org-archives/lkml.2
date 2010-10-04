Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab0JDXmm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 19:42:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54766 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752361Ab0JDXml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 19:42:41 -0400
Date: Mon, 4 Oct 2010 16:42:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Roland McGrath <roland@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@uclinux.org>
Subject: Re: [PATCH RESEND v3 13/24] ptrace: cleanup arch_ptrace() on
 m68knommu
Message-Id: <20101004164205.7e8c0a66.akpm@linux-foundation.org>
In-Reply-To: <1285838880-4977-14-git-send-email-namhyung@gmail.com>
References: <1285838880-4977-1-git-send-email-namhyung@gmail.com>
	<1285838880-4977-14-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Sep 2010 18:27:48 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> Use new 'regno', 'datap' variables in order to remove duplicated
> expressions and unnecessary castings. Alse remove checking @addr
> less than 0 because addr is now unsigned.
> 
> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Acked-by: Greg Ungerer <gerg@uclinux.org>
> ---
>  arch/m68knommu/kernel/ptrace.c |   58 ++++++++++++++++++---------------------
>  1 files changed, 27 insertions(+), 31 deletions(-)

This one gets a large reject due to changes in linux-next, so I skipped
it.

