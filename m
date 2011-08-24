Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab1HXJlm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 05:41:42 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36392 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754878Ab1HXJli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 05:41:38 -0400
Date: Wed, 24 Aug 2011 13:41:33 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110824094133.GN29452@sun>
References: <20110824085329.GL29452@sun>
 <20110824093431.GA3286@htj.dyndns.org>
 <20110824093752.GM29452@sun>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110824093752.GM29452@sun>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 01:37:52PM +0400, Cyrill Gorcunov wrote:
...
> 
> Hmm, good point, letme check...
> 

Yes, Tejun, we need an own revalidate here! So'll update the patch
anyway (will put Pavel's comments into changelog). I somehow forgot
in first place that this entries might be referred even if process is
not stopped. Thanks for chatching it!

	Cyrill
