Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2E0MdB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 08:33:01 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64726 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676Ab2E0Mc5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 08:32:57 -0400
Date: Sun, 27 May 2012 21:23:11 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep warning from 3.4-gitX
Message-ID: <20120527122311.GA26428@kroah.com>
References: <4FC04B80.3000007@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC04B80.3000007@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 10:18:24PM -0500, Larry Finger wrote:
> A newly built mainline kernel that git-describe shows as
> v3.4-7895-g1937f4f has the following lockdep log splat:

<snip>

Known issue, long threads on lkml about it, people are still working it
out, give us some time :)

greg k-h
