Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab1FUKRX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:17:23 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38510 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755957Ab1FUKRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=F0quwWye9HUmAAz15HSk5G3Rc7ASyJ8eOMCfTYvlLNDp6U1q740FWmUwbgu9eqQzGp
         enHZfiB2X0YgA8FsarJlEfolZV4oWUyNux9bq5922ggy3KqF4FY9kQa0f6MwfuwQ4S9Z
         Y5tQ+KdQTvrCr8YyG7IrFypQW/AcVPYzetxNo=
Date: Tue, 21 Jun 2011 11:18:15 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.0-rc3 kmemleak reports
Message-ID: <20110621101815.GB10396@1n450.cable.virginmedia.net>
References: <itpou0$leu$1@dough.gmane.org>
 <20110621095733.GA10396@1n450.cable.virginmedia.net>
 <4E006BB9.90505@itwm.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E006BB9.90505@itwm.fraunhofer.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:00:25PM +0200, Bernd Schubert wrote:
> On 06/21/2011 11:57 AM, Catalin Marinas wrote:
> >On Tue, Jun 21, 2011 at 11:40:15AM +0200, Bernd Schubert wrote:
> >>For some reasons I build a kernel with kmemleak support and got a
> >>few reports.
> >
> >Do you know if they appear in 2.6.39 as well?
> 
> No idea, if it is important I can build a previous kernel version

It would be good, if you have time, as people can at least restrict the
range of commits to check. It could as well be a kmemleak false
positive, can't tell for sure. The ACPI reports are in general difficult
to identify, unless you find some commit that introduced them.

> (but please, no bisecting, I'm too busy with other things).

No problem, thanks anyway.

Thanks.

-- 
Catalin
