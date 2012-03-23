Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2CWOX2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 10:23:28 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:42573 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753395Ab2CWOX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 10:23:26 -0400
Date: Fri, 23 Mar 2012 10:23:22 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 0/9] do not use s_dirt in ext4
Message-ID: <20120323142322.GC29631@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Artem Bityutskiy <dedekind1@gmail.com>,
	Ext4 Mailing List <linux-ext4@vger.kernel.org>,
	Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
	Linux Kernel Maling List <linux-kernel@vger.kernel.org>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
 <20120322133521.GA25897@thunk.org>
 <1332424585.18717.34.camel@sauron.fi.intel.com>
 <20120322150602.GD25897@thunk.org>
 <1332492915.18717.44.camel@sauron.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332492915.18717.44.camel@sauron.fi.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2012 at 10:55:15AM +0200, Artem Bityutskiy wrote:
> On Thu, 2012-03-22 at 11:06 -0400, Ted Ts'o wrote:
> > Does that seem reasonable to you?
> 
> Yes, thank you.

Ok, i've included the first five patches in your patch series in the
ext4 tree.

We can deal with fixing up the rest of the patch series after the
merge window.

					- Ted
