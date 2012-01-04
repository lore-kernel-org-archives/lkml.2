Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932216Ab2ADX2F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 18:28:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59691 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932166Ab2ADX2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 18:28:02 -0500
Date: Wed, 4 Jan 2012 15:28:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
Message-Id: <20120104152801.d8f555ca.akpm@linux-foundation.org>
In-Reply-To: <1324560391.1964.8.camel@falcor>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
	<1324560391.1964.8.camel@falcor>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 08:26:30 -0500
Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Thu, 2011-12-22 at 12:54 +0200, Dmitry Kasatkin wrote:
> > When a file is truncated with truncate()/ftruncate() and then closed,
> > iversion is not updated. This patch uses ATTR_SIZE flag as an indication
> > to increment iversion.
> > 
> > Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> 
> Acked-by: Mimi Zohar <zohar@us.ibm.com> 
> (Stable should be cc'ed on this patch.)

why?
