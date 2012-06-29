Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531Ab2F2JOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:14:09 -0400
Received: from webmail-out1.one.com ([91.198.169.16]:49750 "EHLO
	webmail-out1.one.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2F2JOH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:14:07 -0400
X-Greylist: delayed 529 seconds by postgrey-1.27 at vger.kernel.org; Fri, 29 Jun 2012 05:14:07 EDT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
From: "Zoltan Kelemen" <zoltan.kelemen@digisec.se>
To: "Dan Carpenter" <dan.carpenter@oracle.com>
CC: willy@meta-x.org, gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging:panel: Rewrite for fixing synchronization
 issues
Date: Fri, 29 Jun 2012 11:05:16 +0200
X-Mailer: One.com webmail
X-Originating-Ip: 91.198.169.179
In-Reply-To: <20120629072441.GN5333@mwanda>
References: <4FECC539.8040303@digisec.se> <20120629072441.GN5333@mwanda>
Message-Id: <20120629090516.8845AD52AA77@bmail04.one.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 jun 2012 09:24 "Dan Carpenter" <dan.carpenter@oracle.com> wrote:

> Gar...  Don't do this.  :/  Each bullet point here should be a
> separate patch.  Please break it apart and resend.

I understand a large patch is harder to audit than small incremental changes, but the patch was the result of a code rewrite, where I attempted to summarize the changes in large in the bulleted list. There isn't a one-to-one correspondence between a bullet and a change in the code. Breaking the rewrite into small pieces would not only be quite hard but to some extent even more confusing to audit since you risk to see the leaves instead of the tree.

> Do not create lock_pprt() and unlock_pprt() functions.  It doesn't
> save any lines of code.  It means that Sparse is unable check for

Good point. (The functions were a remnant from previous work-in-progress where they were used in common from process/softirq code, and used different lock calls depending on the context of the call).

Regards,
Zoltan
