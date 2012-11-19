Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735Ab2KSO3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 09:29:09 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:37179 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2KSO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 09:29:08 -0500
Date: Mon, 19 Nov 2012 14:33:07 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Gao feng <gaofeng@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] pidns: remove the useless function is_container_init
Message-ID: <20121119143307.GA4620@mail.hallyn.com>
References: <1353321882-30491-1-git-send-email-gaofeng@cn.fujitsu.com>
 <20121119141224.GA4321@mail.hallyn.com>
 <87obitad1v.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87obitad1v.fsf@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> "Serge E. Hallyn" <serge@hallyn.com> writes:
> 
> > Quoting Gao feng (gaofeng@cn.fujitsu.com):
> >> since commit 1cdcbec1a3372c0c49c59d292e708fd07b509f18,
> >> is_container_init has no used for a long time.
> >> 
> >> just remove it.
> >
> > Only thing is it's being exported, so I think it needs to go through
> > deprecation.
> 
> Exports do not create an ABI.  No internal kernel users are enough.

Ok.  I personally don't know of any out of tree users anyway, just seemed
like a warning for one cycle would be friendly :)

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

thanks,
-serge
