Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab1JJSZY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 14:25:24 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:45371 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab1JJSZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 14:25:23 -0400
Subject: Re: [PATCH 3/6] udf: Rename udf_warn to udf_warn
From: Paul Bolle <pebolle@tiscali.nl>
To: Joe Perches <joe@perches.com>
Cc: Jan Kara <jack@suse.cz>, NamJae Jeon <linkinjeon@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <6444365c4b22de07d3690de95a7912badfb73e80.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com>
	 <cover.1318233879.git.joe@perches.com>
	 <6444365c4b22de07d3690de95a7912badfb73e80.1318233879.git.joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 10 Oct 2011 20:25:05 +0200
Message-ID: <1318271105.18122.5.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-10 at 01:08 -0700, Joe Perches wrote:
> Rename udf_warning to udf_warn for consistency with normal logging
> uses of pr_warn.

So the summary should read:
    udf: Rename udf_warning to udf_warn


Paul Bolle

