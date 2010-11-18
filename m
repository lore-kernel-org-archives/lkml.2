Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757318Ab0KRNGd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 08:06:33 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:33974 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944Ab0KRNGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 08:06:32 -0500
Date: Thu, 18 Nov 2010 06:06:30 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Lukas Czerner <lczerner@redhat.com>
Cc: tytso@mit.edu, linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, sandeen@redhat.com,
        Josef Bacik <josef@redhat.com>
Subject: Re: [PATCH 1/2] fs: Do not dispatch FITRIM through separate
	super_operation
Message-ID: <20101118130630.GJ6178@parisc-linux.org>
References: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290065809-3976-1-git-send-email-lczerner@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 08:36:48AM +0100, Lukas Czerner wrote:
> There was concern that FITRIM ioctl is not common enough to be included
> in core vfs ioctl, as Christoph Hellwig pointed out there's no real point
> in dispatching this out to a separate vector instead of just through
> ->ioctl.

Um, are you and Josef working independently of each other?  You don't
seem to be cc'ing each other on your patches, and you're basically doing
the same thing.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
