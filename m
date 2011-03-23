Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1CWH7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 03:59:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52103 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab1CWH7Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 03:59:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/7] char/mei: PCI device and char driver support.
Date: Wed, 23 Mar 2011 08:59:12 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        Oren Weil <oren.jer.weil@intel.com>, linux-kernel@vger.kernel.org,
        david@woodhou.se
References: <1300791092-14319-1-git-send-email-oren.jer.weil@intel.com> <20110322222259.GA26362@suse.de> <20110322230437.0a2668e2@lxorguk.ukuu.org.uk>
In-Reply-To: <20110322230437.0a2668e2@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103230859.12759.arnd@arndb.de>
X-Provags-ID: V02:K0:enEiknahVGXjjyIhZs0U9klyNa9dQEr5x3pI1yBGKl5
 lk+qMxH7f5euI1cm69n+Kss14JSXIP/jVkD14PmBrmMf9/Q6UO
 p8+RQqgPaaU24nPRtyNj4IHo4AQMwwxpRUYet677Ocw1+jufXO
 iGghiTG7gxA0n5Azs1cJ+HMd0vX1z6cX7udxWSAz4UtPXzJnQM
 g8AQlHwnKFVpYykb6TuJg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Alan Cox wrote:
> On Tue, 22 Mar 2011 15:22:59 -0700
> Greg KH <gregkh@suse.de> wrote:
> 
> > On Tue, Mar 22, 2011 at 09:57:59PM +0000, Alan Cox wrote:
> > > > * In the PCI probe function, create a misc character device for
> > > >   ". Remove the global
> > > >   variables and constants.
> > > 
> > > The current code is complex and could be a ton simpler but don't
> > > abuse misc devices when you have one per PCI instance please.
> > 
> > The code specifically says it only supports one device in the system at
> > a time.  Since it can't do any more than that, why wouldn't it be
> > correct for a misdevice to be used here?
> 
> Arnd was suggesting one device for "every instance you find behind each
> device" so that isn't a good idea for a misc device given there will be
> lots of them.

Yes, makes sense. I was assuming that the common case was that there
is only a single instance.

	Arnd
