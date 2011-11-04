Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab1KDP0S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 11:26:18 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:40336 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755859Ab1KDP0L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 11:26:11 -0400
X-Sasl-enc: VIRylI5jybkhYt5cS1AIGSIq/8wsBTcI1NdX4T69bR2f 1320420370
Date: Fri, 4 Nov 2011 08:23:35 -0700
From: Greg KH <greg@kroah.com>
To: Borislav Petkov <bp@amd64.org>
Cc: linux-stable <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL 3.1.x-stable] AMD F15h cache aliasing fixes
Message-ID: <20111104152335.GA29754@kroah.com>
References: <20111104112209.GB8020@aftab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111104112209.GB8020@aftab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 04, 2011 at 12:22:10PM +0100, Borislav Petkov wrote:
> Hi Greg,
> 
> as previously discussed, here are the 4 patches needed for addressing
> the issue in $Subject. I'm sending them as mails but I have them also in
> a git-pullable form in case you'd like to verify them:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git l1i-3.1.x

I can't take a pull request, your emails are fine.

I'll comment on them individually, in the patches.

greg k-h
