Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab2AaO4n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 09:56:43 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52871 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753237Ab2AaO4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 09:56:41 -0500
X-Sasl-enc: G65+P8p6EsGN+o9EnN8q/oiRXnLHyB9xzeX9Xo2onidS 1328021800
Date: Tue, 31 Jan 2012 06:55:58 -0800
From: Greg KH <greg@kroah.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jslaby@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        ML netdev <netdev@vger.kernel.org>, Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH] sysfs:  Update the name hash when renaming sysfs entries
Message-ID: <20120131145558.GA27810@kroah.com>
References: <4F27120A.4040106@suse.cz>
 <CAPXgP12Sr2KzGJ9RA13QBOCkctb-z3O4+1uHOjANgMDDv2pxaQ@mail.gmail.com>
 <4F27C54F.1010107@suse.cz>
 <CAPXgP11=U_Y3LvJB2LRnXQ53y1WQQTqc0j1c7iva6ZXvF97wEw@mail.gmail.com>
 <4F27C9D4.3040105@suse.cz>
 <CAPXgP12pj6esZVmN-PYTVgJ+_MaAfmpa9hKoKKQZ+Y=Y-Kb4eA@mail.gmail.com>
 <4F27CDBC.5020201@suse.cz>
 <CAPXgP1371fgmaP3ecxsDJ2BmJrOS6kUP95G1BHe6deBPk5FVCQ@mail.gmail.com>
 <m18vko6jmv.fsf@fess.ebiederm.org>
 <m1zkd45411.fsf_-_@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1zkd45411.fsf_-_@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 06:40:26AM -0800, Eric W. Biederman wrote:
> 
> This fixes a bug introduced with sysfs name hashes where renaming a
> network device appears to succeed but silently makes the sysfs files for
> that network device inaccessible.
> 
> In at least one configuration this bug has stopped networking from
> coming up during boot.
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  fs/sysfs/dir.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)

Thanks for this, I'll queue it up later today.

greg k-h
