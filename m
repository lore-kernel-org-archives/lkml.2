Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab0DOOvI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:51:08 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:40170 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513Ab0DOOvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:51:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=meSlsg4KjtBCjLwYwLQpnQHP4gOUo+U1RSBVu4bhTlcHDOAOzz094m4FJsOT2G3LhW
         Dt4nLFlUiRbIydcd+RuX+BQG27kA4Xbn3us2desi3f5xFdu1EjOwtBkK8zdBlnoawHIn
         WLNxlfkppmyYkVtCTzTwcsEpAj4v3xAcD2mkg=
MIME-Version: 1.0
In-Reply-To: <s2u887f81cc1004150114l96254dfcmf5590d24f8418d00@mail.gmail.com>
References: <x2nc27429821004142322i3ce6756dib9c1a3f86000c5f5@mail.gmail.com>
	 <s2u887f81cc1004150114l96254dfcmf5590d24f8418d00@mail.gmail.com>
Date: Thu, 15 Apr 2010 20:21:06 +0530
Message-ID: <l2uc27429821004150751q165f8ae9m5611c6c6444f5a7e@mail.gmail.com>
Subject: Re: [Question] integrating KDB with linux kernel
From: santosh <santosh.iitg@gmail.com>
To: anil kumar <m.anilkumar80@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 1:44 PM, anil kumar <m.anilkumar80@gmail.com> wrote:
> Hello,
>
> Looks like system is running in graphical mode. First go to terminal
> of system (e.g using alt+ctrl+1)  and then invoke kdb
>

Thanks Anil.

Now I am able to invoke "kdb" and run the commands like "dmesg" , bt, etc..

But one problem is still there.

Both "Numlock"  and "CapsLock"  are keep on blinking when I invoke kdb
and becomes normal ( i.e  stop continuous blinking ) when I comes out
of KDB prompt by running the command "go".

Though its not affecting KDb opeartions s but still why the leds are blinking ??

regards
santosh
