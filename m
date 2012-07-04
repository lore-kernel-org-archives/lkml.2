Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933725Ab2GDHua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 03:50:30 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:64300 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932986Ab2GDHuZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 03:50:25 -0400
Date: Wed, 4 Jul 2012 11:50:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [rfc 3/7] procfs: Add ability to plugin auxiliary fdinfo
 providers
Message-ID: <20120704075020.GC1999@moon>
References: <20120627110116.201735815@openvz.org>
 <20120627110512.574379921@openvz.org>
 <4FF3F332.5030302@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF3F332.5030302@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2012 at 11:39:30AM +0400, Pavel Emelyanov wrote:
> 
> How about introducing one more file_operations member and call it in the
> seq_show() (if exists)? Only inotify, eventfd and eventpoll will implement
> one. This will allow to avoid all this complexity with drivers.

Hmm. Thanks for idea, I need to estimate which impact it will have. Will ping
back once it's done.

	Cyrill
