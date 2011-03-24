Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab1CXMDh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 08:03:37 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:44384 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab1CXMDg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 08:03:36 -0400
Date: Thu, 24 Mar 2011 13:03:07 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Heiher <admin@heiher.info>
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        David Daney <ddaney@caviumnetworks.com>, akmp@linux-mips.org
Subject: Re: [PATCH] Fixup personality in different ABI.
Message-ID: <20110324120307.GA20408@linux-mips.org>
References: <AANLkTikuBxnd0bFsO5NP2GQYDZmGFP9kLruWVpjZ7+UQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikuBxnd0bFsO5NP2GQYDZmGFP9kLruWVpjZ7+UQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 12:58:23PM +0800, Heiher wrote:
> Date:   Fri, 18 Mar 2011 12:58:23 +0800
> From: Heiher <admin@heiher.info>
> To: linux-kernel@vger.kernel.org

Please don't post a patch seperately to multiple lists.  Cc is prefered
so everybody gets to see all replies.

> >From bf3637153bc5e3d0e3f1c2982c323057a8e04801 Mon Sep 17 00:00:00 2001
> From: Heiher <admin@heiher.info>
> Date: Fri, 18 Mar 2011 12:51:08 +0800
> Subject: [PATCH] Fixup personality in different ABI.
> 
> * 'arch' output:
> 	o32 : mips
> 	n32 : mips64
> 	64  : mips64

That's the correct behaviour - the personality gets inherited by the parent.
If you want to invoke a process with a different personality you can do this
with a utility like arch32 or setarch.

  Ralf
