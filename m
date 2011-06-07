Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1FGOyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 10:54:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31943 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754748Ab1FGOyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 10:54:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <BANLkTikkBgYx2qPVEXyyAbr0Vsi=_vORqA@mail.gmail.com>
References: <BANLkTikkBgYx2qPVEXyyAbr0Vsi=_vORqA@mail.gmail.com> <1307443181-22278-2-git-send-email-me@akshayjoshi.com> <1307443181-22278-6-git-send-email-me@akshayjoshi.com> <23758.1307453446@redhat.com>
To: Akshay Joshi <me@akshayjoshi.com>
Cc: dhowells@redhat.com, Jiri Slaby <jslaby@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, James Morris <jmorris@namei.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] Kernel: fix spaces with respect to the coding style in sys.c.
Date: Tue, 07 Jun 2011 15:54:18 +0100
Message-ID: <26045.1307458458@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Akshay Joshi <me@akshayjoshi.com> wrote:

> I am very new to submitting patches to the kernel. Do I just modify the
> patch file and add an Acked-by line to the patch notes or do I have to do
> something else?

If you've got a whole bunch of acks, then it may make sense to resubmit your
patches with them included and a note in patch 0 saying that that's all that
you've done.  This is one of the downsides of this process - it doesn't cope
so easily with additions of this type.

David
