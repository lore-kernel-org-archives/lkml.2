Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab2DDLys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 07:54:48 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51549 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756106Ab2DDLyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 07:54:47 -0400
Date: Wed, 4 Apr 2012 15:54:43 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        WANG Cong <amwang@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do notify userspace when there is change in
 uts_kern_table.
Message-ID: <20120404115443.GD24382@moon>
References: <1333539391-11036-1-git-send-email-sasikanth.v19@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333539391-11036-1-git-send-email-sasikanth.v19@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 04, 2012 at 05:06:31PM +0530, Sasikantha babu wrote:
> sethostname and setdomainname notifies userspace on failure (without modifying uts_kern_table) too
> 
> Notify userspace if there is change in uts_kern_table, on failure don't notify userspace 
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>

Reviewed-by: Cyrill Gorcunov <gorcunov@openvz.org>

Looks reasonable to me.
