Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2D1NFl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 09:05:41 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47382 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2D1NFj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 09:05:39 -0400
MIME-Version: 1.0
In-Reply-To: <20120427160919.086dff9d.akpm@linux-foundation.org>
References: <4F998FDE.5020104@redhat.com> <CAHGf_=qLX7gofwHoSKpHLp7nvD6qJtHbmYzAR0UQ42JbfnYerw@mail.gmail.com>
 <20120427160919.086dff9d.akpm@linux-foundation.org>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Sat, 28 Apr 2012 09:05:16 -0400
Message-ID: <CAHGf_=o5+Tk_jdDxSQv4qZpaktV=ukhj=jospW9GDY7qqeVYow@mail.gmail.com>
Subject: Re: [PATCH -mm V3] do_migrate_pages() calls migrate_to_node() even if
 task is already on a correct node
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lwoodman@redhat.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Christoph Lameter <cl@linux.com>, Motohiro Kosaki <mkosaki@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/4/27 Andrew Morton <akpm@linux-foundation.org>:
> On Thu, 26 Apr 2012 21:14:16 -0400
> KOSAKI Motohiro <kosaki.motohiro@gmail.com> wrote:
>
>> From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
>> Cc: Motohiro Kosaki <mkosaki@redhat.com>
>> Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>
> umm, help.  What is your preferred email address ;)

Now I'm using gmail address, but I'm still using fujitsu.com address for
patch signing. Because of, 1) identification from folks and 2) keep easier
making statistics. so then, in short,  jp.fujitsu.com please. :)
