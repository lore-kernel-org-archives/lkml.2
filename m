Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202Ab2GYQLf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 12:11:35 -0400
Received: from lobo.ruivo.org ([173.14.175.98]:43508 "EHLO lobo.ruivo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab2GYQLe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 12:11:34 -0400
Date: Wed, 25 Jul 2012 12:11:20 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: aris@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] userns: convert some filesystems to kuid/kgid
Message-ID: <20120725161120.GA5478@cathedrallabs.org>
References: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342033282-24933-1-git-send-email-arozansk@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,
On Wed, Jul 11, 2012 at 03:01:17PM -0400, Aristeu Rozanski wrote:
> Hi,
> this patchset converts 9p, ADFS, AFFS, AFS and autofs4 to use kuid and kgid.
> I plan to work on the other pending filesystems too but wanted some feedback
> on the first ones first.

had any chance to look at these?

--
Aristeu
