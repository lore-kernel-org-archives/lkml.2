Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab1FHUkx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:40:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2650 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752953Ab1FHUku (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:40:50 -0400
Subject: Re: [PATCH] checkpatch: Validate signature styles and To: and Cc:
 lines
From: Joe Perches <joe@perches.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        anish singh <anish198519851985@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110608202408.GA20393@elliptictech.com>
References: <BANLkTi=AFbSXzjRHuY=uBFz=64C6vWLwNA@mail.gmail.com>
	 <100617f66cdceab04a87514d47929a4ec3aebc19.1307561278.git.joe@perches.com>
	 <20110608202408.GA20393@elliptictech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Jun 2011 13:40:47 -0700
Message-ID: <1307565647.16453.18.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-08 at 16:24 -0400, Nick Bowler wrote:
> On 2011-06-08 12:34 -0700, Joe Perches wrote:
> > Signatures have many forms and can sometimes cause problems
> > if not in the correct format when using git send-email or quilt.
> > Try to verify the signature tags and email addresses to use
> > the generally accepted "Signed-off-by: Full Name <email@domain.tld>"
> > form.
> [...]
> > +			my $suggested_email = format_email(parse_email($email));
> > +			if ($suggested_email eq "") {
> > +				ERROR("email address '$email' is unrecognizable\n" . $herecurr);
> > +			} elsif ($suggested_email ne $email) {
> > +				WARN("email address '$email' might be better as '$suggested_email'\n" . $herecurr);
> If you're going to make suggestions, you should at the very least ensure
> that the suggestions are actually valid email addresses.  Otherwise,
> this script will suggest replacing valid addresses with invalid ones!

Anyone that puts angle brackets in a quoted name
is pretty silly.  There aren't any in git history.

What I did is pretty simple and covers most all
normally used cases.

You are free to improve email parsing.


