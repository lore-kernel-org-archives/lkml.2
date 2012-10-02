Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2JBIFJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 04:05:09 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:37201 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab2JBIE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 04:04:59 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.255.235]
In-Reply-To: <506A2439.2050408@xenotime.net>
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au>
 <5060DA6B.3030806@xenotime.net> <506A2439.2050408@xenotime.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 2 Oct 2012 10:04:38 +0200
Message-ID: <CAK=Wgbaj0=2Q9+NT=TJoTe-41HPo-AJwP-RLN1-dRcPygL2ozg@mail.gmail.com>
Subject: Re: linux-next: Tree for Sept 24 (remoteproc)
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 1:16 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> This build still fails on linux-next of 20121001 when
> VIRTIO is not enabled.

I meant to send this to 3.6-rc, but now that 3.6 is out, I've pushed
it on remoteproc's for-next branch and will send it to 3.7.

It will show up on linux-next the next time Stephen pulls the for-next branches.

Thanks,
Ohad.
