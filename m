Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932575Ab0CaIOl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 04:14:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:59034 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932315Ab0CaIOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 04:14:37 -0400
Message-ID: <4BB30520.2030100@kernel.org>
Date: Wed, 31 Mar 2010 17:17:36 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, Kay Sievers <kay.sievers@vrfy.org>,
       linux-kernel@vger.kernel.org, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
       Benjamin LaHaise <bcrl@lhnet.ca>, Serge Hallyn <serue@us.ibm.com>,
       netdev@vger.kernel.org, Benjamin Thery <benjamin.thery@bull.net>
Subject: Re: [PATCH 3/6] sysfs: Implement sysfs tagged directory support.
References: <m1fx3hk6gw.fsf@fess.ebiederm.org>	<1269973889-25260-3-git-send-email-ebiederm@xmission.com>	<4BB2F083.1050803@kernel.org> <m11vf12ayb.fsf@fess.ebiederm.org>
In-Reply-To: <m11vf12ayb.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 31 Mar 2010 08:14:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Eric.

On 03/31/2010 04:43 PM, Eric W. Biederman wrote:
>> Is it at all possible to implement it in properly layered manner?
>> ie. sysfs providing mechanisms for selective visibility, driver model
>> wraps it and exports it and namespace implements namespaces on top of
>> those mechanisms?
> 
> I think that is roughly what I have.

Yeah, well, in a sense.  It's all a matter of degree.

> As for the layering itself.  Down in sysfs there are only two bits
> visible.  A void * pointer that in addition to the name is what we use
> to define selective visibility.  A context that we capture when we
> mount sysfs.  Those bits are fundamental things sysfs needs to do.

Well, I guess all I wanna say is... is there *ANY* way to do it w/
less callbacks?  It's very difficult to follow what's going on for
what.

If you think all those callbacks are absolute necessities, can you
please at least add boatload of comments around them explaning what
they're meant to do and how they're gonna be used?  It's probably
because I don't have any experience with namespaces but I really can't
wrap my head around it as it currently stands.

Thanks.

-- 
tejun
