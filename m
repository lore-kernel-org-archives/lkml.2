Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2JATnf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 15:43:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42563 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076Ab2JATnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 15:43:33 -0400
Date: Mon, 1 Oct 2012 12:43:31 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Daniel Santos <daniel.santos@pobox.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-sparse@vger.kernel.org, Akinobu Mita <akinobu.mita@gmail.com>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Don Zickus <dzickus@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v6 0/25] Generic Red-Black Trees
Message-Id: <20121001124331.540a2615.akpm@linux-foundation.org>
In-Reply-To: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
References: <1348797281-25021-1-git-send-email-daniel.santos@pobox.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 20:54:16 -0500
Daniel Santos <daniel.santos@pobox.com> wrote:

> This patch set improves on Andrea Arcangeli's original Red-Black Tree
> implementation by adding generic search and insert functions with
> complete support for:

I grabbed patches 1-7, but I don't expect to send them in for 3.7. 
It's not a good time to be merging new material, but I like cleanups.

