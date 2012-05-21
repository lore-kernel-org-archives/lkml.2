Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753050Ab2EUPWi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 11:22:38 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34382 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752967Ab2EUPWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 11:22:36 -0400
Date: Mon, 21 May 2012 18:26:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH NEXT]staging: "rts_pstor" Fix typos.
Message-ID: <20120521152626.GE4629@mwanda>
References: <1337609955-15544-1-git-send-email-justinmattock@gmail.com>
 <20120521143530.GC4637@mwanda>
 <4FBA5737.3010209@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBA5737.3010209@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 07:54:47AM -0700, Justin P. Mattock wrote:
> On 05/21/2012 07:35 AM, Dan Carpenter wrote:
> >On Mon, May 21, 2012 at 07:19:15AM -0700, Justin P. Mattock wrote:
> >>From: "Justin P. Mattock"<justinmattock@gmail.com>
> >>
> >>  Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
> >   ^
> >Your scripts are adding an extra space here.i
> 
> after git format-patch my signature is in the subject line. pressing
> enter a few times moves it down. is there a git command for properly
> aligning this?

The first line is the subject and then you need to leave the next
line of the commit blank.

regards,
dan carpenter

