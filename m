Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755179Ab1FTOnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 10:43:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42752 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754630Ab1FTOne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 10:43:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nj0tkexDtVpmoEk8L7UGKcDUkmhVa8GjhUcrksiqLjFjQBhw8Su9g8aPW67D0p2Rk2
         FUFlqb6Sl7vzVKIOQu0XOmtnQAjx2a3CduvembRl81sPfiwoFGS/hBRg1LI2hofgSTQ2
         NBcP66/1AJn1DBVdbwBAWdo7YRIe7+JUruTqA=
Date: Mon, 20 Jun 2011 18:43:28 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        apparmor@lists.ubuntu.com,
        "selinux@tycho.nsa.gov Stephen Smalley" <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>, Eric Paris <eparis@parisplace.org>,
        John Johansen <john.johansen@canonical.com>,
        kernel-hardening@lists.openwall.com, serge@hallyn.com
Subject: Re: [RFC v2] security: intoduce ptrace_task_may_access_current
Message-ID: <20110620144328.GA11933@albatros>
References: <20110617171152.GA1389@albatros>
 <4DFF5795.9080609@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF5795.9080609@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 10:22 -0400, Eric Paris wrote:
> serge even if you disagree with all of that, you are definitely
> going to need to review the capability changes added here.
> Personally I'd like to see all of the capability changes done as a
> separate patch from the ptrace changes.

I'm afraid the patch series will not be bisectable (capabilities and
ptrace code are very interconnected), but I'll try.


-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
