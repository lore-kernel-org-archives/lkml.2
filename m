Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab2AKHf5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:35:57 -0500
Received: from tundra.namei.org ([65.99.196.166]:53848 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752457Ab2AKHf4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:35:56 -0500
Date: Wed, 11 Jan 2012 18:35:50 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [GIT] Security subsystem updates for 3.3
In-Reply-To: <CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1201111834570.2966@tundra.namei.org>
References: <alpine.LRH.2.00.1201091252220.18816@tundra.namei.org> <CA+55aFwD2-bhd32L1SsjPQrpwOBhBdxTUaOj=oXN24vPwc+Wsg@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012, Linus Torvalds wrote:

> Hmm. The CONFIG_MPI/DIGSIG thing really should go away as a question,
> I think. I'd expect modules that need it to select it, there's no
> point in asking a user "do you want this enabled" afaik.

Ok.

> 
> And "DIGSIG" is really a horrible config name. Did somebody run out of
> letters suddenly? Is there some global letter shortage that I haven't
> been told of and that we should do something about?

Any objections to DIGITAL_SIGNATURE_API ?

> But I pulled it. Please do fix it up, though.

Thanks, will do.


- James
-- 
James Morris
<jmorris@namei.org>
