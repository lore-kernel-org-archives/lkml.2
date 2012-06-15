Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab2FOPtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:49:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:33907 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315Ab2FOPtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:49:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120615135319.GF4400@mwanda>
References: <20120614172523.GB4400@mwanda>
	<20120615014835.GA5695@localhost>
	<20120615071222.GZ13539@mwanda>
	<20120615075810.GA13206@localhost>
	<alpine.DEB.2.02.1206150639130.1864@hadrien>
	<20120615111913.GA13539@mwanda>
	<CA+MoWDrKJwiK66zpBxQ=q+qS7n_P4qLySgBRdj2txq20wa7bvA@mail.gmail.com>
	<20120615135319.GF4400@mwanda>
Date: Fri, 15 Jun 2012 12:49:08 -0300
Message-ID: <CA+MoWDrrk3q+019h=q2Uxue3ZDy4tFEVv5nBwaQhrLxDYOBHJQ@mail.gmail.com>
Subject: Re: automated warning notifications
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Fengguang Wu <wfg@linux.intel.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Josh Triplett <josh@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 10:53 AM, Dan Carpenter
<dan.carpenter@oracle.com> wrote:
> Dropped the Sparse people from the CC list.
>
> On Fri, Jun 15, 2012 at 10:33:50AM -0300, Peter Senna Tschudin wrote:
>> Added git-blame support...
>>
>
> No.  I meant that it would run git blame on the offending line, take
> the hash and then do a git show $hash.

http://pastebin.com/cZCPQuzH

>
> regards,
> dan carpenter
>



-- 
Peter Senna Tschudin
peter.senna@gmail.com
gpg id: 48274C36
