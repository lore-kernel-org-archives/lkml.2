Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211Ab0GMRxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 13:53:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33804 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab0GMRxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 13:53:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=ZIPx6EGPZ14WcLBvO3UWxeb9OyxeEgacAXfuXK+AQtE8m47tnR998uLwDA3611pyPd
         E5Lyb7V3eilvsPMsZq+JzuxE0Sb0yqezvolFmcslzOG4hFHVW6RPFfbnKV3uWenI2Npz
         oXfIvGgqXpfOrKGluVJQZkX8HOA5hsY35mzMQ=
MIME-Version: 1.0
In-Reply-To: <AANLkTikMcPcldBh_uVKxrH7rEIUju3Y_3X2jLi9jw2Vs@mail.gmail.com>
References: <1278756333-6850-1-git-send-email-lliubbo@gmail.com>
	<AANLkTikMcPcldBh_uVKxrH7rEIUju3Y_3X2jLi9jw2Vs@mail.gmail.com>
Date: Tue, 13 Jul 2010 20:53:11 +0300
X-Google-Sender-Auth: VOuy33p1Ttqxy0SwXcFw3i5PPAw
Message-ID: <AANLkTinif3HZDfS6UEHS5v2b1qVdU3qqStEjE7bOIWks@mail.gmail.com>
Subject: Re: [PATCH] slob_free:free objects to their own list
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Bob Liu <lliubbo@gmail.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, mpm@selenic.com,
        hannes@cmpxchg.org, LKML <linux-kernel@vger.kernel.org>,
        Mel Gorman <mel@csn.ul.ie>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 8:52 PM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> It would be nice to have some fragmentation numbers for this. One
> really simple test case is to grep for MemTotal and MemFree in
> /proc/meminfo. I'd expect to see some small improvement with your
> patch applied.

Small correction: grep them immediately after you've booted up the
kernel. If you run applications, the numbers are not comparable.
