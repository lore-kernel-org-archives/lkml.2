Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab2IRQ6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 12:58:01 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:62153 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab2IRQ57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 12:57:59 -0400
Date: Tue, 18 Sep 2012 16:57:58 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Dave Jones <davej@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.orgB>
Subject: Re: Taint kernel when we detect a corrupted slab.
In-Reply-To: <20120918150543.GA14718@redhat.com>
Message-ID: <00000139da509650-e5756e3f-f538-4735-afcd-c3c8ac9035b7-000000@email.amazonses.com>
References: <20120918150543.GA14718@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2012, Dave Jones wrote:

> It doesn't seem worth adding a new taint flag for this, so just re-use
> the one from 'bad page'

Acked-by: Christoph Lameter <cl@linux.com>
