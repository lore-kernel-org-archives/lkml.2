Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab2GERpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:45:00 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52524 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752687Ab2GERo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:44:58 -0400
Date: Thu, 5 Jul 2012 21:44:54 +0400
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
Message-ID: <20120705174454.GD16586@moon>
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
> On 06/27/2012 03:01 PM, Cyrill Gorcunov wrote:
> > This patch brings ability to plugin auxiliary fdinfo providers.
> > For example in further patches eventfd, evenpoll and fsnotify
> > will print out information associated with files.
> > 
> > This feature is CONFIG_CHECKPOINT_RESTORE guarded to eliminate
> > overhead for those who don't need it at all (this
> > unfortunately makes patch bigger than I wanted).
> 
> How about introducing one more file_operations member and call it in the
> seq_show() (if exists)? Only inotify, eventfd and eventpoll will implement
> one. This will allow to avoid all this complexity with drivers.

Hi Pavel, yes, this might be an option, if people agree with this approach
I'll redo my patches (this will require to remake all the rest patches so
I would like to know people opinion before start doint that). Anyone?

	Cyrill
