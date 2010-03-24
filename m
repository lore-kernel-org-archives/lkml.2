Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755654Ab0CXLRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 07:17:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755376Ab0CXLRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 07:17:17 -0400
Subject: Re: [Cluster-devel] [PATCH 10/18] gfs2: Provide config option for
 enabling trace points
From: Steven Whitehouse <swhiteho@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       cluster-devel@redhat.com
In-Reply-To: <1269388565.5363.380.camel@localhost>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <1269304340-25372-11-git-send-email-jack@suse.cz>
	 <1269345667.2438.12.camel@localhost>  <1269388565.5363.380.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Wed, 24 Mar 2010 11:20:57 +0000
Message-ID: <1269429657.2350.1.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, 2010-03-23 at 19:56 -0400, Steven Rostedt wrote:
> On Tue, 2010-03-23 at 12:01 +0000, Steven Whitehouse wrote:
> > Hi,
> > 
> > Now in the GFS2 -nmw git tree. Thanks,
> > 
> 
> Note, this depends on patch 1 which we have not yet determined if it
> should be applied or not.
> 
> -- Steve
> 
Sorry, I think I misread the initial message. I can roll it out again if
required. I did a compile test in both states though and it seemed to
work for me,

Steve.


