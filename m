Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603Ab1HXJjr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:39:47 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53949 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751395Ab1HXJjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:39:43 -0400
Date: Wed, 24 Aug 2011 13:37:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110824093752.GM29452@sun>
References: <20110824085329.GL29452@sun>
 <20110824093431.GA3286@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824093431.GA3286@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 11:34:31AM +0200, Tejun Heo wrote:
> Hello,
> 
> On Wed, Aug 24, 2011 at 12:53:29PM +0400, Cyrill Gorcunov wrote:
> > +static const struct dentry_operations tid_map_files_dentry_operations = {
> > +	.d_revalidate	= pid_revalidate,
> > +	.d_delete	= pid_delete_dentry,
> > +};
> 
> Why pid_revalidate?  Shouldn't it be verifying the entry against the
> current vmas?  vmas (of course) can change while the process is
> running.
> 
> Thanks.
> 

Hmm, good point, letme check...

	Cyrill
