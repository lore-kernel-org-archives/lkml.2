Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab2AEAgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 19:36:46 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34335 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757296Ab2AEAgn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 19:36:43 -0500
Subject: Re: [PATCH v3 1/1] vfs: iversion truncate bug fix
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Kasatkin <dmitry.kasatkin@intel.com>, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Date: Wed, 04 Jan 2012 19:33:49 -0500
In-Reply-To: <20120104152801.d8f555ca.akpm@linux-foundation.org>
References: <ba9643a815137d64301559f174f6f6bf3a552b16.1324551152.git.dmitry.kasatkin@intel.com>
		<1324560391.1964.8.camel@falcor>
	 <20120104152801.d8f555ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1325723630.13419.2.camel@falcor>
Mime-Version: 1.0
x-cbid: 12010500-2398-0000-0000-0000032C6752
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 15:28 -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 08:26:30 -0500
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > On Thu, 2011-12-22 at 12:54 +0200, Dmitry Kasatkin wrote:
> > > When a file is truncated with truncate()/ftruncate() and then closed,
> > > iversion is not updated. This patch uses ATTR_SIZE flag as an indication
> > > to increment iversion.
> > > 
> > > Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
> > 
> > Acked-by: Mimi Zohar <zohar@us.ibm.com> 
> > (Stable should be cc'ed on this patch.)
> 
> why?

Why backported?  The IMA measurement list could be incomplete.

Mimi

