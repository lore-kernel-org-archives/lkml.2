Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610Ab1COERH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 00:17:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52618 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750758Ab1COERD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 00:17:03 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
References: <AANLkTi=_cZRNPU29+MJkt9u6zDSLo153CKqLqg1+t7O6@mail.gmail.com> <alpine.DEB.2.00.1103142011550.16032@chino.kir.corp.google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 14 Mar 2011 21:14:08 -0700
Message-ID: <AANLkTinj2sXd0tu=Xv8E76hQRmGb9eebKeJSYW5syMjW@mail.gmail.com>
Subject: Re: Linux 2.6.38
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 8:13 PM, David Rientjes <rientjes@google.com> wrote:
> This kernel includes a broken commit that was merged a couple of hours
> before release:

Actually, it doesn't. It got reverted before the release because of
the worries about it.

                     Linus
