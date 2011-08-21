Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab1HUVx6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 17:53:58 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:45430 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752693Ab1HUVx6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 17:53:58 -0400
Date: Sun, 21 Aug 2011 14:53:55 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Wanlong Gao <wanlong.gao@gmail.com>
Cc: linux-kernel@vger.kernel.org, gregkh <greg@kroah.com>
Subject: Re: [Doc] class_find_device: fix reference to argument
Message-Id: <20110821145355.94fb7923.rdunlap@xenotime.net>
In-Reply-To: <loom.20110821T164259-39@post.gmane.org>
References: <201108211256.43836.eike@sf-mail.de>
	<loom.20110821T164259-39@post.gmane.org>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Aug 2011 14:46:04 +0000 (UTC) Wanlong Gao wrote:

> Rolf Eike Beer <eike <at> sf-mail.de> writes:
> 
> > 
> > Signed-off-by: Rolf Eike Beer <eike-kernel <at> sf-tec.de>
> > ---
> >  drivers/base/class.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> 
> > - * @fn is allowed to do anything including calling back into class
> > + * @match is allowed to do anything including calling back into class
> >   * code.  There's no locking restriction.
> >   */
> >  struct device *class_find_device(struct class *class, struct device *start,
> 
> NACK, it means the function class_find_device but not the @match.

Are you sure?  Looks to me like a comment that was copied from
class_for_each_device() but shouldn't have been copied.

Anyway, I'll cc: Greg to see if he knows.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
