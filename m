Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759021Ab0EVDBs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 23:01:48 -0400
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:44410 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758981Ab0EVDBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 23:01:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=BjEedPGbwK0Pon4ueMfthPSHGHarqN40VgP/bX6qIciGYcLPcUL+b8GrfB2Y+aw1OwGfoVjcJ3dN+S1ZCZtbwN57vLfYMCjqJj5OVT03yn8Z9dlJGy3IBqFswwPAMXJ9;
Date: Fri, 21 May 2010 20:01:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes
Message-ID: <20100521200139.30e60c62@virtuousgeek.org>
In-Reply-To: <alpine.LFD.2.00.1005211859030.3689@i5.linux-foundation.org>
References: <20100521144859.0a5b18c9@virtuousgeek.org>
	<alpine.LFD.2.00.1005211709330.3689@i5.linux-foundation.org>
	<alpine.LFD.2.00.1005211859030.3689@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 May 2010 18:59:58 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Fri, 21 May 2010, Linus Torvalds wrote:
> >
> > I think the "not verified" is also because you actually didn't push it 
> > out..
> > 
> > I'm getting "Already up-to-date".
> > 
> > Or is it in some magic branch that you didn't actually mention at all?
> 
> Ahh. It's in "linux-next". Not "for-linus" or "master".

Yeah sorry, I had pushed but it hadn't mirrored yet...

-- 
Jesse Barnes, Intel Open Source Technology Center
