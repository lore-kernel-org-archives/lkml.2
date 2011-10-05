Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042Ab1JEWUA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 18:20:00 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41584 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932246Ab1JEWUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 18:20:00 -0400
Message-ID: <1317853198.3095.19.camel@Joe-Laptop>
Subject: Re: [PATCH 1/2 v3] udf : enable error print in udf_read_tagged().
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: Namjae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 05 Oct 2011 15:19:58 -0700
In-Reply-To: <20111005220813.GK23467@quack.suse.cz>
References: <1317650037-4648-1-git-send-email-linkinjeon@gmail.com>
	 <20111005220813.GK23467@quack.suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-10-06 at 00:08 +0200, Jan Kara wrote:
> Hello,
> 
> On Mon 03-10-11 22:53:57, Namjae Jeon wrote:
> > While reading metadata, if a problem occurs, Print out only one of the
> > five case.(It also does not show a checksum properly.) Because currently
> > it have been disable by undef udf_debug.  If there is a problem with
> > scratched disc or loader, the user needs to know which error happened.
> > And I use pr_fmt instead of printk by joe's suggestion. I try to modify
> > totally it to pr_fmt also.

>   Thanks for the patch. I'm willing to take the patch since it's an
> improvement but what would be even nicer is to have error reporting like in
> ext3 / ext4. We would have functions udf_info, udf_warn, udf_err which
> also print sb->s_id with each error so that user can better identify on
> which filesystem error happened.

Modifying the follow-on patch I sent would be pretty trivial.


