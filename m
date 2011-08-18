Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab1HRIKd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 04:10:33 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:56287 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1HRIKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 04:10:31 -0400
X-Greylist: delayed 4073 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 04:10:30 EDT
Subject: Re: linux-next: error while fetching the unicore32 tree
From: Guan Xuetao <gxt@mprc.pku.edu.cn>
Reply-To: gxt@mprc.pku.edu.cn
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Xuetao Guan <epip.guan@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110818112247.2b2f302ac633ee7ca394545c@canb.auug.org.au>
References: <20110818112247.2b2f302ac633ee7ca394545c@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: MPRC, PKU
Date: Thu, 18 Aug 2011 14:57:57 +0800
Message-ID: <1313650677.2905.7.camel@epip-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-18 at 11:22 +1000, Stephen Rothwell wrote:
> Hi,
> 
> While fetching the unicore32 tree, I get this error:
> 
> fatal: '/pub/scm/linux/kernel/git/epip/linux-2.6-unicore32.git' does not appear to be a git repository
> 
> I will use the unicore32 tree from yesterday.

I'm sorry.
I have changed unicore32 pathname from linux-2.6-unicore32.git to
linux-unicore.git
Please change unicore32 git repo to:
git://master.kernel.org/pub/scm/linux/kernel/git/epip/linux-unicore.git#unicore32


Thanks Stephen, and sorry for the trouble.

Guan Xuetao


