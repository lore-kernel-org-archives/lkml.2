Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab1COEg0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:36:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42502 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863Ab1COEgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:36:25 -0400
Date: Mon, 14 Mar 2011 21:33:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Rientjes <rientjes@google.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: Linux 2.6.38
Message-Id: <20110314213331.24229139.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com>
	<alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011 20:13:38 -0700 (PDT) David Rientjes <rientjes@google.com> wrote:

> once oom-prevent-unnecessary-oom-kills-or-kernel-panics.patch is merged 
> from -mm

Please (re)send the patches which you believe should be merged into
2.6.38 to address the problems which Oleg found, and any other critical
problems.  Not in a huge rush - let's get this right.
