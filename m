Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166Ab1IHJlm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 05:41:42 -0400
Received: from mx4-phx2.redhat.com ([209.132.183.25]:53121 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758126Ab1IHJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 05:41:41 -0400
Date: Thu, 8 Sep 2011 05:41:22 -0400 (EDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: Alex Bligh <alex@alex.org.uk>
Cc: nbd-general@lists.sf.net, Paul Clements <Paul.Clements@steeleye.com>,
        linux-kernel@vger.kernel.org
Message-ID: <1951246803.1122458.1315474882425.JavaMail.root@zmail07.collab.prod.int.phx2.redhat.com>
In-Reply-To: <0049F93FE7CC864CB1D8147A@nimrod.local>
Subject: Re: [Nbd] [PATCH v2 2/2] nbd: map DISCARD requests to a new nbd
 request	type
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.5.5.72]
X-Mailer: Zimbra 6.0.9_GA_2686 (ZimbraWebClient - FF3.0 (Linux)/6.0.9_GA_2686)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do you have a patch for doc/proto.txt in the NBD protocol, or indeed
> a patch for the server to implement this?

I have a patch for the client to invoke the new ioctl, and a patch for
qemu-nbd to both invoke the new ioctl (client-side) and implement the
command (server-side).

I'll look at doc/proto.txt and propose a patch, that can be done off
LKML if the series is accepted.

Paolo
