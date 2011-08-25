Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab1HYRL4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 13:11:56 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:38467 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab1HYRLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 13:11:55 -0400
Date: Thu, 25 Aug 2011 21:11:50 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Vasiliy Kulikov <segoon@openwall.com>, Nathan Lynch <ntl@pobox.com>,
        Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        James Bottomley <jbottomley@parallels.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>, containers@lists.osdl.org,
        Zan Lynx <zlynx@acm.org>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] fs, proc: Introduce the /proc/<pid>/map_files/ directory v2
Message-ID: <20110825171150.GB6387@sun>
References: <20110824085329.GL29452@sun>
 <20110824111806.GA7191@albatros>
 <20110825082944.GH10030@sun>
 <20110825170147.GM2803@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110825170147.GM2803@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 07:01:47PM +0200, Tejun Heo wrote:
...
> 
> Hmm... don't we need the same credential update as
> tid_fd_revalidate()?  If the task seteuid's, we want the permissions
> to change accordingly, right?
> 
> Thanks.
>

Exactly! Thanks Tejun. I'll be reworking it anyway (acoording to what
we decide to do with start-end range in names).
 
	Cyrill
