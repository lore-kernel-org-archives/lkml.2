Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0DDDoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Apr 2010 23:44:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52785 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751918Ab0DDDoA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Apr 2010 23:44:00 -0400
Date: Sat, 3 Apr 2010 20:39:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: Linux 2.6.34-rc3
In-Reply-To: <4BB24E5F.3030703@lwfinger.net>
Message-ID: <alpine.LFD.2.00.1004032032160.3634@i5.linux-foundation.org>
References: <4BB24E5F.3030703@lwfinger.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 30 Mar 2010, Larry Finger wrote:
>
> I understand that you do not want a whole set of such "fix one such bug at a
> time" patches, but the bottom line is that these lockdep warnings for known
> problems interfere with "normal" debugging because further lockdep checking is
> disabled. I do not feel qualified to detect other cases and fix them. Only when
> a warning hits my logs am I qualified to fix and test.

I'd actually like the owner for this to send me the patches - I don't go 
out downloading things from patchwork, and quite frankly, I was expecting 
Eric Biederman to follow up on these issues, since that's where the new 
requirements came from. Maybe the patches are already waiting in Greg's 
tree or something?

But if people are just waiting around for others to take them, if somebody 
who has tracked this issue (hint hint, Larry) sends me the final patches, 
I can take them that way too.

		Linus
