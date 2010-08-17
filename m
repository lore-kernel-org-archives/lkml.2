Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690Ab0HQKzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 06:55:25 -0400
Received: from mx6.sophos.com ([213.31.172.36]:47323 "EHLO mx6.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899Ab0HQKzY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 06:55:24 -0400
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Andreas Gruenbacher <agruen@suse.de>
Subject: Re: [GIT PULL] notification tree - try 37!
Date: Tue, 17 Aug 2010 11:55:20 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.34-12-desktop; KDE/4.4.4; x86_64; ; )
CC: Eric Paris <eparis@redhat.com>, Christoph Hellwig <hch@infradead.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Michael Kerrisk <michael.kerrisk@gmail.com>
References: <1281110319.17812.21.camel@dhcp231-200.rdu.redhat.com> <201008171201.10142.agruen@suse.de> <201008171112.42097.tvrtko.ursulin@sophos.com>
In-Reply-To: <201008171112.42097.tvrtko.ursulin@sophos.com>
MIME-Version: 1.0
Message-ID: <201008171155.21479.tvrtko.ursulin@sophos.com>
X-MIMETrack: Itemize by SMTP Server on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 17/08/2010 11:55:21,
	Serialize by Router on Mercury/Servers/Sophos(Release 7.0.3|September 26, 2007) at
 17/08/2010 11:55:22,
	Serialize complete at 17/08/2010 11:55:22
X-TNEFEvaluated: 1
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 Aug 2010 11:12:41 Tvrtko Ursulin wrote:
> On Tuesday 17 Aug 2010 11:01:09 Andreas Gruenbacher wrote:
> > I'm quite sure that both of these issues have been discussed already.
>
> Ok, I obviosuly missed it. Do you have a pointer perhaps?

I have found the thread. It has been discussed but I do not find it had a
clear outcome. At the end Eric has proposed the heartbeat/in-progress option
(which IMHO can only work together with a timeout) to which no-one objected. I
did not find other arguments against such functionality solid.

Tvrtko


Sophos Plc, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 348 3873 20.
