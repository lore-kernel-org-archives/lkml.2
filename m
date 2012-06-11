Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584Ab2FKK6L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:58:11 -0400
Received: from natasha.panasas.com ([67.152.220.90]:60681 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab2FKK6A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:58:00 -0400
Message-ID: <4FD5CF1A.40807@panasas.com>
Date: Mon, 11 Jun 2012 13:57:30 +0300
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111113 Thunderbird/8.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Miklos Szeredi <miklos@szeredi.hu>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <hch@infradead.org>,
        <torvalds@linux-foundation.org>, <dhowells@redhat.com>,
        <mszeredi@suse.cz>
Subject: Re: [PATCH 00/21] vfs: atomic open v6 (part 2)
References: <1338901832-14049-1-git-send-email-miklos@szeredi.hu> <20120610034921.GB30000@ZenIV.linux.org.uk> <20120610111056.GD30000@ZenIV.linux.org.uk> <20120610175605.GE30000@ZenIV.linux.org.uk>
In-Reply-To: <20120610175605.GE30000@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 08:56 PM, Al Viro wrote:

> On Sun, Jun 10, 2012 at 12:10:56PM +0100, Al Viro wrote:
> 
>> WARNING: I haven't even tried to boot it.  It builds, but this is all I can
>> promise at the moment.  I'm about to fall down (it's 7am here already ;-/),
>> will give it some beating when I get up.  It almost certainly has bugs, so
>> consider that as call for review and not much more.
> 
> OK, it boots, mounts NFS and even manages to build a kernel on it.  Which
> probably would meet Linus' "it's perfect, ship it" criteria, so go ahead
> and beat it up, folks.


If the "manages to build a kernel on it" part involves a "git clone" first
then I agree. From past bug I found that even if xfstest cthon and bunch of
other testes pass, I still got data-corruption/bugs under 
"git clone linux, umount, mount, git status". It's my best test so far.
(It needs to be a very big git tree with lots of history as well, like linux or gcc)

Cheers
Boaz
