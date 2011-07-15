Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1GOQKf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 12:10:35 -0400
Received: from mail.perches.com ([173.55.12.10]:4029 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab1GOQKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 12:10:34 -0400
Subject: Re: [PATCH 11/11] dynamic_debug: use a single printk() to emit msgs
From: Joe Perches <joe@perches.com>
To: Jason Baron <jbaron@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>, gregkh@suse.de, jim.cromie@gmail.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110715160417.GB2493@redhat.com>
References: <cover.1310657068.git.jbaron@redhat.com>
	 <3667c0a87dd8fd64fdf1b1e8107b130a9b41096e.1310657068.git.jbaron@redhat.com>
	 <CAO+b5-qA3s92YX2izXzvzt3MOrzRaPcZtDtK0cDte0ZXnRWxhA@mail.gmail.com>
	 <1310744914.7582.36.camel@Joe-Laptop>
	 <CAO+b5-p2B74+oVQRGcGxMp5ULZy8ZmF215Lz4qhbU=C4RnG8dw@mail.gmail.com>
	 <20110715160417.GB2493@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Jul 2011 09:10:32 -0700
Message-ID: <1310746232.7582.47.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 12:04 -0400, Jason Baron wrote:
> but that approach uses 'KERN_CONT'. The point of patch 11/11 is to get rid
> of KERN_CONT, which is racy. 

Not "racy" really, but it can be interleaved
by other threads so using KERN_CONT can make
the output difficult to read.

