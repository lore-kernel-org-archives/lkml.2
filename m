Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933218Ab1CWQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:09:59 -0400
Received: from verein.lst.de ([213.95.11.211]:46458 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933123Ab1CWQJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:09:58 -0400
Date: Wed, 23 Mar 2011 17:09:57 +0100
From: Christoph Hellwig <hch@lst.de>
To: Michael Reeves <reeves.87@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: journaled hfsplus write support
Message-ID: <20110323160957.GA9988@lst.de>
References: <2D7188A7-1F73-422D-AC34-99DB02631AA3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2D7188A7-1F73-422D-AC34-99DB02631AA3@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 12:03:13PM -0400, Michael Reeves wrote:
> I am interested in trying to get journaling support into the HFS plus driver for linux. Was there any particular reason this has not been done yet?

Mostly because it's going to be a lot of work.  If you want to try it feel
free, the structure seems to be reasonably documented in the Apple
technote.
