Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754610Ab2EGFZN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 01:25:13 -0400
Received: from ozlabs.org ([203.10.76.45]:51537 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973Ab2EGFYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 01:24:17 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Sasha Levin <levinsasha928@gmail.com>, davem@davemloft.net,
        ericvh@gmail.com, aneesh.kumar@linux.vnet.ibm.com,
        jvrao@linux.vnet.ibm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, davej@redhat.com,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [PATCH] 9p: disconnect channel when PCI device is removed
In-Reply-To: <1334353716-19483-1-git-send-email-levinsasha928@gmail.com>
References: <1334353716-19483-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 07 May 2012 12:45:16 +0930
Message-ID: <87397chebf.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2012 17:48:36 -0400, Sasha Levin <levinsasha928@gmail.com> wrote:
> When a virtio_9p pci device is being removed, we should close down any
> active channels and free up resources, we're not supposed to BUG() if there's
> still an open channel since it's a valid case when removing the PCI device.
> 
> Otherwise, removing the PCI device with an open channel would cause the
> following BUG():

(Damn changed notmuch.el bindings!  Previous reply went only to Sasha).

Applied thanks,
Rusty.
