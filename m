Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934709Ab1ESUeX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:34:23 -0400
Received: from Mycroft.westnet.com ([216.187.52.7]:36591 "EHLO
	mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934645Ab1ESUeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:34:22 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <19925.32442.357561.198470@quad.stoffel.home>
Date: Thu, 19 May 2011 16:34:02 -0400
From: "John Stoffel" <john@stoffel.org>
To: Andy Whitcroft <apw@canonical.com>
Cc: John Stoffel <john@stoffel.org>, Miklos Szeredi <miklos@szeredi.hu>,
        viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        nbd@openwrt.org, neilb@suse.de, hramrach@centrum.cz,
        jordipujolp@gmail.com
Subject: Re: [PATCH 0/7] overlay filesystem v9
In-Reply-To: <20110519203018.GK3702@shadowen.org>
References: <1305635452-14835-1-git-send-email-miklos@szeredi.hu>
	<20110519163709.GH3702@shadowen.org>
	<87sjsak2jt.fsf@tucsk.pomaz.szeredi.hu>
	<19925.27077.673335.609614@quad.stoffel.home>
	<20110519203018.GK3702@shadowen.org>
X-Mailer: VM 8.1.1 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Andy" == Andy Whitcroft <apw@canonical.com> writes:

Andy> On Thu, May 19, 2011 at 03:04:37PM -0400, John Stoffel wrote:
>> One question I have is why is a LiveCD even using the LSM modules?
>> It's not like it tells you anything you don't know... unless you're
>> planning on mounting some external disks and then reading in the LSM
>> checksums from somewhere to confirm.
>> 
>> Just curious.  

Andy> Cause the LiveCD has the same kernel we want in the installed
Andy> system on it, so its there warts and all.

Can't argue with that then.  
