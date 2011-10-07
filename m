Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758616Ab1JGSKY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:10:24 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54787 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1JGSKT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:10:19 -0400
MIME-Version: 1.0
In-Reply-To: <14824.1318004546@turing-police.cc.vt.edu>
References: <20111006190526.GA13883@redhat.com>
	<201110071640.53827.frank.mehnert@oracle.com>
	<CA+5PVA4v0D_ppnjN_k_6AcDEfH_U0Nn9WLfb3J84JGBGBOFBsg@mail.gmail.com>
	<14824.1318004546@turing-police.cc.vt.edu>
Date: Fri, 7 Oct 2011 14:10:18 -0400
Message-ID: <CA+5PVA7iFDm17faPowUNNh3BnYMxUGPXRzbu9vkbVWW1m9Hvfg@mail.gmail.com>
Subject: Re: RFC: virtualbox tainting.
From: Josh Boyer <jwboyer@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Frank Mehnert <frank.mehnert@oracle.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andy Hall <andy.hall@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 7, 2011 at 12:22 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> On Fri, 07 Oct 2011 11:16:13 EDT, Josh Boyer said:
>> In all seriousness, is there a reason these modules haven't been
>> submitted to the staging tree?  Perhaps this was attempted in the past
>> and I'm just not finding references to it.
>
> I haven't actually checked what the churn rate of the kernel side of VirtualBox is, but
> there *is* some benefit if you have a package that includes both userspace and kernel
> code, to keep them in sync.

I haven't checked either, which is why I asked Frank directly since
I'm assuming he has ;).

> Currently, VirtualBox is at 4.1.4.  Now, if they decide they need to change/fix/extend
> the API for some reason, they can just ship a 4.1.6 and be happy.  If the code is
> in-tree, then they are basically stuck with the API - they can't ship a 4.1.6 that can
> get away with assuming that all the kernel API is there.  So you have to carry around
> workarounds and test-for-features code and all that stuff.

Yeah, I'm familiar with that line of reasoning.  It can be beneficial
to vbox itself, but then we have situations like this where users are
picking up that single-source package and trying to run it on distros
that change kernel versions rather frequently and that doesn't seem to
benefit anyone.  The users are left with a buggy machine/vbox
instance, the distributions are left with unhappy users, and vbox is
left with unhappy users AND unhappy distribution maintainers.
(Somehow the distributions get the brunt of the blame from the users,
but I'm not going to go down that path.  I'm trying to be productive.)

> I don't know - maybe the Oracle crew think the API is stable enough now that they can
> afford to do that.  But Frank would probably be the one to speak to how in/out of tree
> would affect their development/support methodology.

Yes.  Which is why I asked Frank :).

josh
