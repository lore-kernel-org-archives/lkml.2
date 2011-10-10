Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab1JJS11 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:27:27 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:59732 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752825Ab1JJS10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:27:26 -0400
Message-ID: <1318271245.27825.36.camel@Joe-Laptop>
Subject: Re: [PATCH 3/6] udf: Rename udf_warn to udf_warn
From: Joe Perches <joe@perches.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Jan Kara <jack@suse.cz>, NamJae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Mon, 10 Oct 2011 11:27:25 -0700
In-Reply-To: <1318271105.18122.5.camel@x61.thuisdomein>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	 <cover.1318233879.git.joe@perches.com>
	 <6444365c4b22de07d3690de95a7912badfb73e80.1318233879.git.joe@perches.com>
	 <1318271105.18122.5.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 20:25 +0200, Paul Bolle wrote:
> On Mon, 2011-10-10 at 01:08 -0700, Joe Perches wrote:
> > Rename udf_warning to udf_warn for consistency with normal logging
> > uses of pr_warn.
> 
> So the summary should read:
>     udf: Rename udf_warning to udf_warn

Yeah, I stuffed that subject line up.
Jan/Honza caught it and fixed it though.

