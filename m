Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031295Ab2CVWAX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:00:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:32789 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031165Ab2CVWAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:00:20 -0400
Date: Thu, 22 Mar 2012 15:00:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, <eric.dumazet@gmail.com>,
        <vapier@gentoo.org>, <asharma@fb.com>
Subject: Re: [PATCH] fs/notify/notification.c: make subsys_initcall function
 static
Message-Id: <20120322150019.eff74bc8.akpm@linux-foundation.org>
In-Reply-To: <201203211145.17416.hartleys@visionengravers.com>
References: <201203211145.17416.hartleys@visionengravers.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 11:45:17 -0700
H Hartley Sweeten <hartleys@visionengravers.com> wrote:

> subsys_initcall functions should be marked static.

Well, I suppose there are legitimate situations where they could be
non-static(?), although those would be rather bizarre.

A better reason for making this static is that it has no references
outside this file.

