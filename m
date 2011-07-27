Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1G0QCe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:02:34 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:41442 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754502Ab1G0QCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:02:32 -0400
Date: Wed, 27 Jul 2011 09:02:27 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, dhowells@redhat.com, ebiederm@xmission.com,
        containers@lists.linux-foundation.org, netdev@vger.kernel.org,
        akpm@osdl.org, "Serge E. Hallyn" <serge.hallyn@canonical.com>
Subject: Re: [PATCH 01/14] add Documentation/namespaces/user_namespace.txt
Message-Id: <20110727090227.d03c7173.rdunlap@xenotime.net>
In-Reply-To: <20110727153848.GA17288@hallyn.com>
References: <1311706717-7398-1-git-send-email-serge@hallyn.com>
	<1311706717-7398-2-git-send-email-serge@hallyn.com>
	<20110726132249.69533206.rdunlap@xenotime.net>
	<20110727153848.GA17288@hallyn.com>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011 15:38:48 +0000 Serge E. Hallyn wrote:

> > > +Working notes
> > > +=============
> > 
> > A lot of this file is working notes and will need to be updated...
> 
> Yup.  I can leave it out of this file and keep it on the wiki instead, if
> that is preferred.

Either place is OK with me, as long as you continue to update it
and don't let it go stale.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
