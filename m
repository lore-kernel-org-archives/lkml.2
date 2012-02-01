Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415Ab2BAVRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:17:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2BAVRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:17:47 -0500
Date: Wed, 1 Feb 2012 13:17:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <dyoung@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
Message-Id: <20120201131746.07e2219e.akpm@linux-foundation.org>
In-Reply-To: <20120201063420.GA10204@darkstar.nay.redhat.com>
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 14:34:20 +0800
Dave Young <dyoung@redhat.com> wrote:

> tools/ is the better place for vm tools which are used by many people.
> Moving them to tools also make them open to more users instead of hide in
> Documentation folder.
> 

It would be nice to covert these into simple pass/fail tests and
promote them to tools/testing/selftests/.

