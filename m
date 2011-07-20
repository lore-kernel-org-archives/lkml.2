Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1GTJbV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 05:31:21 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54037 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072Ab1GTJbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 05:31:20 -0400
MIME-Version: 1.0
In-Reply-To: <CACTFLANrd0FO9GNJpvS+MxnQgLLtXpA-sai30oYN90cjEFOErA@mail.gmail.com>
References: <CACTFLANAFT=G4kFvHUqvLrt=MxgpJnJ-EeHY8zd49pZvsNRejw@mail.gmail.com>
	<1311139283.20738.150.camel@sauron>
	<CACTFLANrd0FO9GNJpvS+MxnQgLLtXpA-sai30oYN90cjEFOErA@mail.gmail.com>
Date: Wed, 20 Jul 2011 11:31:19 +0200
Message-ID: <CACTFLAO0-2QDVxVD0_qFwtExaf3=UHDvZDtSVePEi4ca=DBfbw@mail.gmail.com>
Subject: Re: Regression in handling of unsafe UBI shutdown
From: Daniel Mack <zonque@gmail.com>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sven Neumann <s.neumann@raumfeld.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:18 AM, Daniel Mack <zonque@gmail.com> wrote:
> Also note that it's not the kernel itself that complains about the
> state of the file system in this case but U-Boot. If we boot a 3.0-rc7
> kernel in such a situation (via USB for example), the kernel will
> recover the FS and continue.

And I forgot to mention that the mtd-toturetest didn't show any
problems, so it's most likely not an issue with the block-device
layer.


Btw - Adrian Hunter's address <adrian.hunter@nokia.com> bounces - can
anyone care to update the UBI record in MAINTAINERS with a new
address? :)


Thanks,
Daniel
