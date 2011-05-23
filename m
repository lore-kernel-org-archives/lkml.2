Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751966Ab1EWFPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 01:15:01 -0400
Received: from smtp-out.google.com ([216.239.44.51]:37991 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab1EWFO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 01:14:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=AYDvZoPcOwplEyE42jP8PKMzgsg2mODcGtGwvWVLk6sFkdmcFjHYqlpVKDMnIAlsnx
         7eej+J4T7ezXVlvD+/5Q==
Date: Sun, 22 May 2011 22:14:28 -0700
From: Mandeep Singh Baines <msb@chromium.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mandeep Singh Baines <msb@chromium.org>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org,
        Marcin Slusarz <marcin.slusarz@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 1/4] watchdog: fix rounding issues in
 get_sample_period()
Message-ID: <20110523051428.GL11023@google.com>
References: <1305588901-8141-1-git-send-email-msb@chromium.org>
 <20110518135302.GM29881@redhat.com>
 <20110519162631.GJ11023@google.com>
 <20110520115118.GF14745@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110520115118.GF14745@elte.hu>
X-Operating-System: Linux/2.6.32-gg426-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mandeep Singh Baines <msb@chromium.org> wrote:
> 
> > Ingo, since Don is out, would you mind acking the patches (assuming you're 
> > happy). It simplifies pushing these patches into our local ChromiumOS tree if 
> > I have an upstream ack.
> 
> I suspect it would simplify things even more for you if they were all upstream, 
> right?
> 

Most definitely:)

> To get that process underway please send an updated series with (delta) patches 
> against -tip.
> 

Rebased series against tip/master and resent:

* Message-Id: <1306127423-3347-1-git-send-email-msb@chromium.org>

> Thanks,
> 
> 	Ingo
