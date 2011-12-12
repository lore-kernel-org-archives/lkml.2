Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab1LLKdA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 05:33:00 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42662 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab1LLKc7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 05:32:59 -0500
MIME-Version: 1.0
In-Reply-To: <1323684748.16764.62.camel@twins>
References: <20111210104341.592561407@chello.nl>
	<20111210104840.295857663@chello.nl>
	<CACVXFVPKgg98UBDaCC9eU605mRYrtCiPH6+zQLcvdY2Hp4LMYg@mail.gmail.com>
	<1323529084.16764.5.camel@twins>
	<CACVXFVNMAtJBdNK6Yb6C34=Ke93X3AOkWq022_n4GTUMEn2HJw@mail.gmail.com>
	<1323546551.2822.14.camel@laptop>
	<CACVXFVNAAXAWtTncahb=sADHxmZOmdDOJA1FUX8Qt4ZR3To_qg@mail.gmail.com>
	<1323607627.16764.13.camel@twins>
	<CACVXFVOYj+Mmph8WGQUdcGS8t-GPr9y3crPuz0SrBCtOmCvstQ@mail.gmail.com>
	<1323617738.16764.21.camel@twins>
	<1323636148.16764.44.camel@twins>
	<CACVXFVMDEeDBkAdv=AkRZuOH1sNdMGjR3PeHYMVLhwR+FB8gOg@mail.gmail.com>
	<1323680078.16764.45.camel@twins>
	<CACVXFVPOsUrEEDT=iMZyrvaX3G_XqWpVOJyz24=FPTtB_9J9HQ@mail.gmail.com>
	<1323684748.16764.62.camel@twins>
Date: Mon, 12 Dec 2011 18:32:58 +0800
Message-ID: <CACVXFVNUGTu-gF=jkNg37cmc1wKFvycYojs96VS8eowyLsJ8fg@mail.gmail.com>
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
From: Ming Lei <tom.leiming@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: gregkh@suse.de, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        ostrikov@nvidia.com, adobriyan@gmail.com, eric.dumazet@gmail.com,
        mingo@elte.hu, Oliver Neukum <oneukum@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 6:12 PM, Peter Zijlstra <peterz@infradead.org> wrote:

> I don't know the driver model, and I don't plan to start learning it
> now. But if what you said is possible its broken and no memory barriers
> will fix it.

IMO, you don't need to learn it, and my example is very simple and common
kref usage in device drivers, :-)

Could we only focus on it and see what is problem? and why won't memory
barrier fix it?

Anyway, device drivers are the most consumers of kref...

thanks,
-- 
Ming Lei
