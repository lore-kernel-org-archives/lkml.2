Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab1ADJYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 04:24:45 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62527 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab1ADJYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 04:24:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=A2ohnrw0BZAOgT3foOFwKMPPkUqRNLzRJsm5L98XgOzvODL4r+L1EV2qwioRAWvB4T
         J21JunMUApDlD2+iCq7f71c2m2e6HUS+0TXqA8gj/EvICrz9FZk8Bjr4WpUrUwwNSIuI
         chT7P30lFeks02dXBkU49aSMh5XntuCdu4uhM=
Date: Tue, 4 Jan 2011 12:24:31 +0300
From: Dan Carpenter <error27@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] checkpatch: putting the && or || on the wrong line
Message-ID: <20110104092431.GB1886@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Joe Perches <joe@perches.com>, Andy Whitcroft <apw@canonical.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20110104055900.GA5062@bicker>
 <1294124330.6617.15.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294124330.6617.15.camel@Joe-Laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 10:58:50PM -0800, Joe Perches wrote:
> On Tue, 2011-01-04 at 08:59 +0300, Dan Carpenter wrote:
> > +			WARN("put the && or || at the end of the previous line\n" . $herecurr);
> 
> I've submitted something like this a couple of times and gotten
> various objections but I think it's sensible.
> 
> https://lkml.org/lkml/2009/12/5/65
> https://lkml.org/lkml/2010/7/11/92

If everyone except you thinks it's a waste of time, then stop asking me
to redo my patches.  :/  I don't care either way so long as CodingStyle
and checkpatch reflect the rules.

regards,
dan carpenter

