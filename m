Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2DPXAQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:00:16 -0400
Received: from gate.crashing.org ([63.228.1.57]:57937 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab2DPXAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:00:15 -0400
Message-ID: <1334617205.25353.12.camel@pasglop>
Subject: Re: [PATCH V2 1/4] vgaarb: Add support for setting the default
 video device
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        airlied@redhat.com, Matt Fleming <matt.fleming@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 17 Apr 2012 09:00:05 +1000
In-Reply-To: <4F8C8689.3030902@zytor.com>
References: <1334607965-9582-1-git-send-email-mjg@redhat.com>
	 <4F8C8689.3030902@zytor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-16 at 13:52 -0700, H. Peter Anvin wrote:
> Acked-by: H. Peter Anvin <hpa@zytor.com>
> 
> ... on this patchset.  I'd like to see it together though, so it's OK
> for me if Dave wants to take it, or I can take it.

Well, I was CCed so here's my Ack :-)

Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

BTW. We should hack a version of vbetool that uses the arbiter
interfaces ... not that I want vbetool to live but it's proved handy
once or twice diagnosing problems...

Cheers,
Ben.


