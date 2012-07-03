Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757260Ab2GCUlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 16:41:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36260 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035Ab2GCUlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 16:41:21 -0400
Date: Tue, 3 Jul 2012 13:41:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        Greg KH <greg@kroah.com>, linux-mm@kvack.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Dave Jones <davej@redhat.com>
Subject: Re: [PATCH -v5 0/6] notifier error injection
Message-Id: <20120703134120.dc89c7ae.akpm@linux-foundation.org>
In-Reply-To: <1341035970-20490-1-git-send-email-akinobu.mita@gmail.com>
References: <1341035970-20490-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2012 14:59:24 +0900
Akinobu Mita <akinobu.mita@gmail.com> wrote:

> This provides kernel modules that can be used to test the error handling
> of notifier call chain failures by injecting artifical errors to the
> following notifier chain callbacks.

No updates to Documentation/fault-injection/?
