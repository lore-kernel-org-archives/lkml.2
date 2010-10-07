Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0JGWqD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:46:03 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:48303 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab0JGWqB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:46:01 -0400
Date: Thu, 7 Oct 2010 23:45:59 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Don Zickus <dzickus@redhat.com>
cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, fweisbec@gmail.com,
        robert.richter@amd.com, gorcunov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] arch generic way to trigger unknown NMIs
In-Reply-To: <20101007140112.GN10663@redhat.com>
Message-ID: <alpine.LFD.2.00.1010072342170.15889@eddie.linux-mips.org>
References: <20101007030807.GA4076@redhat.com> <20101007072641.GE5010@basil.fritz.box> <20101007140112.GN10663@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Oct 2010, Don Zickus wrote:

> No I prefer a single one too, but there didn't seem to be a
> send_IPI_self() command, so I took the short route and sent it to
> everyone. :-(

 Odd, APIC hardware does explicitly support such a mode (there are three 
shorthands like this actually: all-but-self, all and self), so why don't 
just add a suitable wrapper?

  Maciej
