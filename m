Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab0IWSRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 14:17:06 -0400
Received: from szamchat.xatka.net ([195.137.246.111]:51085 "EHLO
	szamchat.xatka.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab0IWSRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 14:17:04 -0400
X-Greylist: delayed 1243 seconds by postgrey-1.27 at vger.kernel.org; Thu, 23 Sep 2010 14:17:04 EDT
Date: Thu, 23 Sep 2010 19:53:50 +0200
From: =?iso-8859-2?Q?Pawe=B3?= Zuzelski <pawelz@pld-linux.org>
To: James Dingwall <james.dingwall@amdocs.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: PROBLEM: [BISECTED] 2.6.35.5 xen domU panics just after the
 boot
Message-ID: <20100923175350.GA4737@davabel.xatka.net>
References: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3B7AEC3C7FCC864282DFAC9A56A7BA363D81475787@UKLNDMAIL1.corp.amdocs.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Sep 2010, James Dingwall wrote:

> > I was experiencing the same immediate crash with a null pointer
> > dereference (log below) on boot with 2.6.35.5.  Reverting
> > fb412a178502dc498430723b082a932f797e4763 also resolved the problem for
> > me.
>
> Checking the diff from this commit it looks like there is a typo in the patch.  With the following (probably mangled by my client) I get 2.6.35.5 to boot.  Suggest it should be a candidate for .32 and .35 stable trees.

I confirm. This patch works for me. Thanks.

-- 
Regards,
Pawe³ Zuzelski
