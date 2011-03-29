Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753436Ab1C2Dcv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 23:32:51 -0400
Received: from linux-sh.org ([111.68.239.195]:37674 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab1C2Dcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 23:32:50 -0400
Date: Tue, 29 Mar 2011 12:32:34 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbcon: Remove unused 'display *p' variable from fb_flashcursor()
Message-ID: <20110329033234.GD7338@linux-sh.org>
References: <20110324205052.GA4238@swordfish> <20110328091846.485dfef0@jbarnes-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110328091846.485dfef0@jbarnes-desktop>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 09:18:46AM -0700, Jesse Barnes wrote:
> On Thu, 24 Mar 2011 22:50:52 +0200
> Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:
> 
> > fbcon: Remove unused 'display *p' variable from fb_flashcursor()
> > 
> > Signed-of-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> > 
> 
> Looks fine to me, is Paul the lucky owner of fbdev now?
> 
Seems so. I'll roll the patch in with the next batch of fixes.
