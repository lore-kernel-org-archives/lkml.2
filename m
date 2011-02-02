Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751706Ab1BBB1k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 20:27:40 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48405 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751334Ab1BBB1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 20:27:39 -0500
Date: Wed, 2 Feb 2011 02:27:33 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Paul Menage <menage@google.com>
Cc: Jordi Pujol <jordipujolp@gmail.com>, linux-kernel@vger.kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC/RFT PATCH] cgroup: enable write permission for the group of
 users
Message-ID: <20110202012733.GA30557@elte.hu>
References: <201102011002.09819.jordipujolp@gmail.com>
 <AANLkTineUvbe4w53zVEyfafs_ERt1NPbRo83KeAH89KF@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTineUvbe4w53zVEyfafs_ERt1NPbRo83KeAH89KF@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul Menage <menage@google.com> wrote:

> On Tue, Feb 1, 2011 at 1:02 AM, Jordi Pujol <jordipujolp@gmail.com> wrote:
> > Hello,
> >
> > Working in a development that uses control groups and libcgroup, I have found
> > that the files in control groups directories need write permission for the
> > group of users also.
> 
> This can be configured from userspace - chmod() works just fine on
> control files in cgroupfs.

Sure, many things can be worked around in user-space, but the question is, does the 
+g make sense as default cgroupfs permissions?

Thanks,

	Ingo
