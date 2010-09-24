Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab0IXPtg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 11:49:36 -0400
Received: from kroah.org ([198.145.64.141]:47023 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753014Ab0IXPtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 11:49:35 -0400
Date: Fri, 24 Sep 2010 08:49:27 -0700
From: Greg KH <greg@kroah.com>
To: Tracey Dent <tdent48227@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] Staging: rtl8187se: r8180.h: fixed alot of
 checkpatch.pl issues
Message-ID: <20100924154927.GA20767@kroah.com>
References: <1285031982-3870-1-git-send-email-tdent48227@gmail.com>
 <20100922232458.GB18432@haskell.muteddisk.com>
 <20100923022256.GB27057@kroah.com>
 <20100924063616.GD18432@haskell.muteddisk.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100924063616.GD18432@haskell.muteddisk.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 11:36:16PM -0700, matt mooney wrote:
> While I have your attention, I am changing all makefiles to use the newer kbuild
> flag variables, such as ccflags-y, asflags-y, and ldflags-y. I have already
> completed this for all directories in the kernel except drivers which is
> next. The patches are trivial but there are a lot in drivers, so should I break
> it down by driver or is subdirectory okay? media/video has 85 instances in
> something like 12 different subdirectories, so I am not sure what is
> best. Please let me know what is best.

It all depends on the subsystem maintainer, I suggest asking them for
what they wish to have you send them.

good luck,

greg k-h
