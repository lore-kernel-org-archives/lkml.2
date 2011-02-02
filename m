Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab1BBLML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 06:12:11 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:33929 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab1BBLMK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 06:12:10 -0500
Subject: Re: [RFC/RFT PATCH] cgroup: enable write permission for the group
 of users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>
Cc: Paul Menage <menage@google.com>, Jordi Pujol <jordipujolp@gmail.com>,
        linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>
In-Reply-To: <20110202012733.GA30557@elte.hu>
References: <201102011002.09819.jordipujolp@gmail.com>
	 <AANLkTineUvbe4w53zVEyfafs_ERt1NPbRo83KeAH89KF@mail.gmail.com>
	 <20110202012733.GA30557@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 02 Feb 2011 12:13:03 +0100
Message-ID: <1296645183.26581.305.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-02-02 at 02:27 +0100, Ingo Molnar wrote:
> * Paul Menage <menage@google.com> wrote:
> 
> > On Tue, Feb 1, 2011 at 1:02 AM, Jordi Pujol <jordipujolp@gmail.com> wrote:
> > > Hello,
> > >
> > > Working in a development that uses control groups and libcgroup, I have found
> > > that the files in control groups directories need write permission for the
> > > group of users also.
> > 
> > This can be configured from userspace - chmod() works just fine on
> > control files in cgroupfs.
> 
> Sure, many things can be worked around in user-space, but the question is, does the 
> +g make sense as default cgroupfs permissions?

I don't think this is anything the kernel can guess, the cgroup
filesystem is root only on initial mount time for a good reason.
Anything thereafter is purely up to userspace.
