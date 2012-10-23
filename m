Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933296Ab2JWTPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 15:15:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43958 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932144Ab2JWTPt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 15:15:49 -0400
Message-ID: <5086ECDE.4030300@suse.com>
Date: Tue, 23 Oct 2012 21:15:42 +0200
From: Andreas Jaeger <aj@suse.com>
Organization: =?ISO-8859-1?Q?SUSE_Linux_Products_GmbH=2C_Nuernber?=
 =?ISO-8859-1?Q?g=2C_GF=3A_Jeff_Hawn=2C_Jennifer_Guild=2C_Fel?=
 =?ISO-8859-1?Q?ix_Imend=F6rffer=2C_HRB_16746_=28AG_Nuernberg=29?=
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Paton J. Lewis" <palewis@adobe.com>
Cc: "mtk.manpages@gmail.com" <mtk.manpages@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jason Baron <jbaron@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Holland <pholland@adobe.com>,
        Davide Libenzi <davidel@xmailserver.org>,
        "libc-alpha@sourceware.org" <libc-alpha@sourceware.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2] epoll: Support for disabling items, and a self-test
 app.
References: <1345756535-8372-1-git-send-email-palewis@adobe.com> <CAKgNAkg0R2LwfpF8beCkawTfPu7oj_DDaDxf2VJ+xB6UTgRSaw@mail.gmail.com> <5086D27F.1000007@adobe.com>
In-Reply-To: <5086D27F.1000007@adobe.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/23/2012 07:23 PM, Paton J. Lewis wrote:
> [Re-sending without HTML formatting; all vger.kernel.org destination
> addresses bounced my original response.]
>
> On 10/16/12 8:12 AM, Michael Kerrisk (man-pages) wrote:
>> [CC += linux-api@]
>
> Thank you; is this sufficient to coordinate the required changes to the
> glibc version of epoll.h?

Paton, we normally review the diffs between kernel versions but noticing 
us via libc-alpha is great.

So, you ask to get this added to <sys/epoll.h>?

#define EPOLL_CTL_DISABLE 4

Once 3.7 is out and contains it, we will add it. A friendly reminder 
once the patch is in would be nice so that we don't miss it during the 
review.

thanks,
Andreas
-- 
  Andreas Jaeger aj@{suse.com,opensuse.org} Twitter/Identica: jaegerandi
   SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
    GF: Jeff Hawn,Jennifer Guild,Felix Imendörffer,HRB16746 (AG Nürnberg)
     GPG fingerprint = 93A3 365E CE47 B889 DF7F  FED1 389A 563C C272 A126
