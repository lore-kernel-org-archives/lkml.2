Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449Ab1ALNXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 08:23:55 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:47457 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab1ALNXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 08:23:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=t8bEdOy/J0ZL0+0SAFF5MG+QV/QFZRq5AJ90CmA66RDJ6mD8UVJ8cmAK6qHo33/ZE7
         RdqUsRv3e33XjlGv5ebIo+h5SZHDXH+OdrQmP60ayU3Sac17/I+DJAC8bgFP0bJ3G1g3
         QVTN9Lm7Fg31eccYJeyxVIjgYGDfX5+bGtYmo=
Date: Wed, 12 Jan 2011 14:23:46 +0100
From: Tejun Heo <tj@kernel.org>
To: oleg@redhat.com, roland@redhat.com, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCHSET RFC] ptrace,signal: clean transition between STOPPED
 and TRACED
Message-ID: <20110112132346.GC10920@mtj.dyndns.org>
References: <1293199257-11255-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293199257-11255-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 03:00:50PM +0100, Tejun Heo wrote:
> This patchset is spun off from "ptrace,signal: sane interaction
> between ptrace and job control signals, take#2" patchset[1].  From the
> series, four fix and cleanup patches were put into git branch
> ptrace-reviewed[2].  This patchset is the subset which tries to fix
> problems with the actual group stop mechanism and make the transition
> between STOPPED and TRACED clean.

Roland, Jan, what do you guys think?

Thank you.

-- 
tejun
