Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab0KZVWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 16:22:38 -0500
Received: from gate.crashing.org ([63.228.1.57]:47843 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab0KZVWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 16:22:38 -0500
Subject: RE: [PATCH v3] ppc44x:PHY fixup for USB on canyonlands board
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Rupjyoti Sarmah <rsarmah@apm.com>
Cc: Wolfgang Denk <wd@denx.de>, linuxppc-dev@ozlabs.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <ade8814261339ab5028557ae3dc15c0b@mail.gmail.com>
References: <201011261110.oAQBANZL012455@amcc.com>
	 <20101126142342.E05A411D94F1@gemini.denx.de>
	 <ade8814261339ab5028557ae3dc15c0b@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 27 Nov 2010 08:22:19 +1100
Message-ID: <1290806539.32570.136.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-26 at 21:02 +0530, Rupjyoti Sarmah wrote:
> Hi Wolfgang,
> 
> >> This results in a mix of "amcc," and "apm," strings.
> >> Are there any plans to unify this?
> We can make all as apm, but right now I believe there is no plan to do so.
> 
> >>Earlier versions of the patch included a delay after the clrbits8()
> >>call as well. Is it intentional that you dropped this now?
> It is dropped intentionally.
> 
> Rest of your suggestions, I will modify and resubmit. Thanks.

I think this should remain consistent within the platform and stick to
"amcc".

Cheers,
Ben.

