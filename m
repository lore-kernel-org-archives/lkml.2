Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab0CXOWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 10:22:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60967 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425Ab0CXOWr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 10:22:47 -0400
X-Authority-Analysis: v=1.0 c=1 a=iGnHfCumZfoA:10 a=IkcTkHD0fZMA:10 a=Kb425h1ZfghOXLSsj94A:9 a=i_-EXrefkvZ0k7A7B1i2tgwIUpoA:4 a=QEXdDO2ut3YA:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [Cluster-devel] [PATCH 10/18] gfs2: Provide config option for
 enabling trace points
From: Steven Rostedt <rostedt@goodmis.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
       cluster-devel@redhat.com
In-Reply-To: <1269429657.2350.1.camel@localhost>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
	 <1269304340-25372-11-git-send-email-jack@suse.cz>
	 <1269345667.2438.12.camel@localhost>  <1269388565.5363.380.camel@localhost>
	 <1269429657.2350.1.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Mar 2010 08:09:01 -0400
Message-ID: <1269432541.3095.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-24 at 11:20 +0000, Steven Whitehouse wrote:
> Hi,
> 
> On Tue, 2010-03-23 at 19:56 -0400, Steven Rostedt wrote:
> > On Tue, 2010-03-23 at 12:01 +0000, Steven Whitehouse wrote:
> > > Hi,
> > > 
> > > Now in the GFS2 -nmw git tree. Thanks,
> > > 
> > 
> > Note, this depends on patch 1 which we have not yet determined if it
> > should be applied or not.
> > 
> > -- Steve
> > 
> Sorry, I think I misread the initial message. I can roll it out again if
> required. I did a compile test in both states though and it seemed to
> work for me,
> 

No problem, I'm just saying I believe without the first patch, this is a
nop. That is, both states have the same result. The trace events stay
in.

-- Steve


