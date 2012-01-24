Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757515Ab2AXVTk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:19:40 -0500
Received: from mx.scalarmail.ca ([98.158.95.75]:60273 "EHLO
	ironport-01.sms.scalar.ca" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755844Ab2AXVTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:19:39 -0500
Date: Tue, 24 Jan 2012 16:19:35 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Dave Hansen <haveblue@us.ibm.com>, Andy Whitcroft <apw@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Matt Helsley <matthltc@us.ibm.com>,
        linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: Re: [RFC] fix devpts mount behavior
Message-ID: <20120124211935.GA21252@elliptictech.com>
References: <20120124000517.GA28878@sergelap>
 <CA+55aFz9ofF+Ey8VCDS8UEf2XSw36kj2RhkHfFScuzLXMeNrkA@mail.gmail.com>
 <20120124002555.GA29534@sergelap>
 <CA+55aFzwOU137V6wtyBjessx05NJo2G4KV0rvTKWvC79A+o9iQ@mail.gmail.com>
 <20120124205502.GC20039@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120124205502.GC20039@us.ibm.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-01-24 12:55 -0800, Sukadev Bhattiprolu wrote:
> Linus Torvalds [torvalds@linux-foundation.org] wrote:
[...]
> | If you can test a few distros and at least validate that the approach
> | isn't *totally* broken, I'll apply it. It's early days in the -rc
> | series yet, and this does seem to be one of those things that we'd be
> | better off trying to do early rather than delay.
> 
> Yes, hopefully the new distros can cope with 'newinstance' as the default
> and ones that can't can live with CONFIG_DEVPTS_MULTIPLE_INSTANCES=n.

What about people who chroot into an "old" distro from a "new" livecd?

Cheers,
-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)

