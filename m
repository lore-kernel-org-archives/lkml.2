Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929Ab2D0XJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:09:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58718 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756818Ab2D0XJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:09:22 -0400
Date: Fri, 27 Apr 2012 16:09:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: lwoodman@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Christoph Lameter <cl@linux.com>, Motohiro Kosaki <mkosaki@redhat.com>
Subject: Re: [PATCH -mm V3] do_migrate_pages() calls migrate_to_node() even
 if task is already on a correct node
Message-Id: <20120427160919.086dff9d.akpm@linux-foundation.org>
In-Reply-To: <CAHGf_=qLX7gofwHoSKpHLp7nvD6qJtHbmYzAR0UQ42JbfnYerw@mail.gmail.com>
References: <4F998FDE.5020104@redhat.com>
	<CAHGf_=qLX7gofwHoSKpHLp7nvD6qJtHbmYzAR0UQ42JbfnYerw@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 21:14:16 -0400
KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Motohiro Kosaki <mkosaki@redhat.com>
> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

umm, help.  What is your preferred email address ;)
