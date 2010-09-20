Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab0ITAw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 20:52:27 -0400
Received: from xenotime.net ([72.52.115.56]:48250 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754348Ab0ITAw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 20:52:26 -0400
Date: Sun, 19 Sep 2010 17:52:20 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@suse.de>
Subject: Re: [PATCH] Documemtation: fix email-clients for gmail
Message-Id: <20100919175220.7e12d924.rdunlap@xenotime.net>
In-Reply-To: <AANLkTi=Fi0i4fjWWaiZ_7E7FSOHqKKCfm9cxD3gLDLZe@mail.gmail.com>
References: <AANLkTi=Fi0i4fjWWaiZ_7E7FSOHqKKCfm9cxD3gLDLZe@mail.gmail.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 Sep 2010 21:21:56 +0800 Hillf Danton wrote:

> If this patch is not unapplyable, then gmail seems not bad for
> delivering patch to vger.kernel.org.

It is unapplyable as is (as received).

> Signed-off-by: Hillf Danton <dhillf@gmail.com>
> ---
> 
> --- o/linux-2.6.36-rc4/Documentation/email-clients.txt	2010-09-13
> 07:07:38.000000000 +0800
> +++ m/linux-2.6.36-rc4/Documentation/email-clients.txt	2010-09-19
> 21:14:16.000000000 +0800
> @@ -216,14 +216,6 @@ Works.  Use "Insert file..." or external
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  Gmail (Web GUI)
> 
> -Does not work for sending patches.
> -
> -Gmail web client converts tabs to spaces automatically.
> -
> -At the same time it wraps lines every 78 chars with CRLF style line breaks
> -although tab2space problem can be solved with external editor.
> -
> -Another problem is that Gmail will base64-encode any message that has a
> -non-ASCII character. That includes things like European names.
> +Works.  Instead of Rich formatting, select Plain Text when preparing patch.

Did not work.
Please see http://lkml.org/lkml/2010/9/19/85.

You can see that something did indeed break the long --- & +++
lines into 2 lines each.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
