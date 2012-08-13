Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2HMRHv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 13:07:51 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:43977 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2HMRHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 13:07:49 -0400
Date: Mon, 13 Aug 2012 10:07:45 -0700
From: Tejun Heo <tj@kernel.org>
To: JoonSoo Kim <js1304@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] workqueue: use system_highpri_wq for unbind_work
Message-ID: <20120813170745.GH9180@google.com>
References: <1344874672-6257-1-git-send-email-js1304@gmail.com>
 <1344874672-6257-5-git-send-email-js1304@gmail.com>
 <20120813163601.GC9180@google.com>
 <CAAmzW4MW_O1LRqJ41zQ47sXAjAyi6U=9LPB=Vbrtj+WhtSU2LQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAAmzW4MW_O1LRqJ41zQ47sXAjAyi6U=9LPB=Vbrtj+WhtSU2LQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 14, 2012 at 02:02:31AM +0900, JoonSoo Kim wrote:
> 2012/8/14 Tejun Heo <tj@kernel.org>:
> > On Tue, Aug 14, 2012 at 01:17:52AM +0900, Joonsoo Kim wrote:
> > Is this from an actual workload?  ie. do you have a test case where
> > this matters?
> 
> No. it is not from an actual workload.
> I got this idea suddenly, during implementing others.
> I will do a test for this tomorrow.

I don't think it's a bad idea and guess this wouldn't make much
difference under most workload.  Was mostly wondering whether this
came from some crazy phone powersave optimization.

Thanks.

-- 
tejun
