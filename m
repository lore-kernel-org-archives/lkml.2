Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755992Ab1D0BiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:38:09 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47955 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755912Ab1D0BiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:38:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=VQ/zGH5ZwMjvzNDs8BYtQFzpm9sjGJ8/VLK+4zsRxBk44OMQZJ5a1Qjhd9oSRlzsiz
         A8HIPXucDCoqorXVb/wMlwGWgrK2dwVnzT9UwmPeV8lvJwbgGQ9RGZp6Nf7qnPSQRllQ
         n7wNgn66iFLHqF9UmbvoxrXWhWYW2UZ4680Ro=
Date: Wed, 27 Apr 2011 09:37:48 +0800
From: Harry Wei <jiaweiwei.xiyou@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: trivial@kernel.org, joe@perches.com, linux-kernel@vger.kernel.org
Subject: Re: [TRIVIAL PATCH] treewide: Cleanup continuations and remove
 logging message whitespace
Message-ID: <20110427013746.GA2018@gmail.com>
Mail-Followup-To: Randy Dunlap <randy.dunlap@oracle.com>,
	trivial@kernel.org, joe@perches.com, linux-kernel@vger.kernel.org
References: <65136ab68431de0cc0c554663cee33fc9d4a9850.1303615717.git.joe@perches.com>
 <20110425082230.6d656ed0.randy.dunlap@oracle.com>
 <20110426024807.GA2751@gmail.com>
 <20110426093434.e999ed24.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110426093434.e999ed24.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 26, 2011 at 09:34:34AM -0700, Randy Dunlap wrote:
> On Tue, 26 Apr 2011 10:48:10 +0800 Harry Wei wrote:
> 
> > 
> > Should we need the line 535? If true, i wanna the function of 
> > 'pr_debug("");'
> 
> Hi Harry,
> 
> Joe sent a different patch for this warning message.
Okay, i see ;)

Thanks.
Harry Wei.
