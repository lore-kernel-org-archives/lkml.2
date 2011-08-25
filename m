Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655Ab1HYTXi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 15:23:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54967 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751120Ab1HYTXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 15:23:37 -0400
Date: Thu, 25 Aug 2011 12:23:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: mmotm 2011-08-24-14-08 uploaded
Message-Id: <20110825122307.face013a.akpm@linux-foundation.org>
In-Reply-To: <20110825135103.GA6431@tiehlicka.suse.cz>
References: <201108242148.p7OLm1lt009191@imap1.linux-foundation.org>
	<20110825135103.GA6431@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Aug 2011 15:51:03 +0200
Michal Hocko <mhocko@suse.cz> wrote:

> On Wed 24-08-11 14:09:05, Andrew Morton wrote:
> > The mm-of-the-moment snapshot 2011-08-24-14-08 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> I have just downloaded your tree and cannot quilt it up.

Parenthetically, there's not much point in running -mm any more:
everything which matters is copied into linux-next, so just run the
following day's -next.

There are a few things in -mm which aren't transferrrred to -next.  Some
akpm-specific pain reducers, a few patches which don't look like
they'll ever get into mainline and a great shower of debugging patches
which I accumulated over the ages.

