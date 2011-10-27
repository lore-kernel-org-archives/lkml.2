Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755294Ab1J0MDO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:03:14 -0400
Received: from smtp-out3.tiscali.nl ([195.241.79.178]:53742 "EHLO
	smtp-out3.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab1J0MDN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:03:13 -0400
Subject: Re: Linux 3.0.8
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net
In-Reply-To: <20111025051928.GA7997@kroah.com>
References: <20111025051928.GA7997@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 27 Oct 2011 14:02:49 +0200
Message-ID: <1319716969.20488.14.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-25 at 07:19 +0200, Greg KH wrote:
> The updated 3.0.y git tree can be found at (NOTE THE ADDRESS CHANGE):
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.0.y
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary

Somehow I seem to be able to generate perfect copies of patch-3.0.4.bz2
(and earlier), by simply doing a command like:
    git diff v3.0 v3.04 | bzip2 -9 > patch-3.0.4-git.bz2 

But for patch-3.0.5 (and above) trivial commands like
     git diff v3.0 v3.0.8 > patch-3.0.8-git

do not generate perfect copies anymore. Have you perhaps changed the way
you generate the patches since v3.0.5?  Not that this matters much,
since tags v3.0.5 (and up) are signed by your "Linux kernel stable
release signing key", but I still wonder what could cause this
difference. Maybe it's just a git upgrade on your side.


Paul Bolle

