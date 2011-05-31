Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758405Ab1EaUO3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:14:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43850 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758248Ab1EaUO2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:14:28 -0400
Message-ID: <4DE54BFD.2090408@zytor.com>
Date: Tue, 31 May 2011 13:13:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [kernel.org users] Turning off the incremental diff robot
References: <4DE3E9E7.8020008@zytor.com> <20110531195201.GB7995@1wt.eu>
In-Reply-To: <20110531195201.GB7995@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2011 12:52 PM, Willy Tarreau wrote:
> 
> Well, I don't think the incremental patches are *that much* used.
> Speaking for my case, my longterm release scripts do produce them
> anyway since it's trivial with git, and I suppose many others do
> as well.
> 
> I suggest that we disable the robot and wait for any possible
> complaints which are to be expected anyway with a version change.
> Then it'll be more productive to help tree owners to adapt their
> scripts than it would be to keep the robot running.
> 

Yes, this would be one option.  It would at least save the effort of
chasing problems when it breaks due to tree-owner changes.

	-hpa
