Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357Ab1ELNeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 09:34:08 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:46401 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757331Ab1ELNeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 09:34:04 -0400
Date: Thu, 12 May 2011 07:34:02 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: matt mooney <mfmooney@gmail.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 00/12] staging: usbip: miscellaneous code cleanup
Message-ID: <20110512133402.GF15227@parisc-linux.org>
References: <cover.1305103212.git.mfm@muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305103212.git.mfm@muteddisk.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 11, 2011 at 01:54:12AM -0700, matt mooney wrote:
> Hi Greg,
> 
> I am interested in hearing your thoughts on the userspace interface?

Hey Matt, if you're looking at usbip, could I interest you in fixing
the protocol that it speaks?  See the thread here:

http://marc.info/?l=linux-kernel&m=122001863119269&w=2

I ran out of time to work on it, but I think the problems still remain.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
