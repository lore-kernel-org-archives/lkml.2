Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab2AKBbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 20:31:07 -0500
Received: from ozlabs.org ([203.10.76.45]:60172 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932469Ab2AKBbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 20:31:04 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Jon Masters <jcm@redhat.com>, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [PATCH] modules: sysfs - export: taint, address, size
In-Reply-To: <1326214063.1038.1.camel@mop>
References: <1325951076.860.2.camel@mop> <871ur99vzf.fsf@rustcorp.com.au> <CAPXgP12rUUYfRy6QB5Z4Rwdday3hNHubCsSRY4gMDYuQGs3oJg@mail.gmail.com> <87zkdw7ayp.fsf@rustcorp.com.au> <1326214063.1038.1.camel@mop>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 11 Jan 2012 10:24:26 +1030
Message-ID: <878vlf6rm5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jan 2012 17:47:43 +0100, Kay Sievers <kay.sievers@vrfy.org> wrote:
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: modules: sysfs - export: taint, coresize, initsize
> 
> Recent tools do not want to use /proc to retrieve module information. A few
> values are currently missing from sysfs to replace the information available
> in /proc/modules.
> 
> This adds /sys/module/*/{coresize,initsize,taint} attributes.
> 
> TAINT_PROPRIETARY_MODULE (P) and TAINT_OOT_MODULE (O) flags are both always
> shown now, and do no longer exclude each other, also in /proc/modules.
> 
> Replace the open-coded sysfs attribute initializers with the __ATTR() macro.
> 
> Add the new attributes to Documentation/ABI.
> 
> Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>

Thanks, applied.

Cheers,
Rusty.
PS.  You could have split this into four separate patches, like the
     pedants wanted, and got more gititude!
PPS.  I'm so glad you didn't.
