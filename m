Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754319Ab1G1DVW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 23:21:22 -0400
Received: from tundra.namei.org ([65.99.196.166]:55989 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674Ab1G1DVP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 23:21:15 -0400
Date: Thu, 28 Jul 2011 13:20:35 +1000 (EST)
From: James Morris <jmorris@namei.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [GIT] Security subsystem changes for 3.1
In-Reply-To: <CA+55aFyyROrBFuwKTWkEWpe=iF=E68bQicQcBpTFrx6Bj2RaBw@mail.gmail.com>
Message-ID: <alpine.LRH.2.00.1107281316550.5116@tundra.namei.org>
References: <alpine.LRH.2.00.1107281209010.4722@tundra.namei.org> <CA+55aFzhg+W86y7TNQ6iqFEibfy+L9irxEHLd9VOy2+mTdWTSA@mail.gmail.com> <alpine.LRH.2.00.1107281240330.4840@tundra.namei.org>
 <CA+55aFyyROrBFuwKTWkEWpe=iF=E68bQicQcBpTFrx6Bj2RaBw@mail.gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jul 2011, Linus Torvalds wrote:

> On Wed, Jul 27, 2011 at 7:42 PM, James Morris <jmorris@namei.org> wrote:
> >
> > Ok, but this conflict was in my subsystem.
> 
> .. but it was a conflict that came from the VFS subsystem changes.
> 
> So it was clearly a cross-subsystem conflict. The fact that the file
> was in what you consider your subsystem IS TOTALLY IRRELEVANT. Because
> clearly somebody ELSE considered the change that conflicted to be part
> of THEIR subsystem!

Ok.  So what should have happened here (fb408e6ccc) is that Al should have 
emailed the patch to me to apply to my tree, instead of pushing it 
directly?


- James
-- 
James Morris
<jmorris@namei.org>
