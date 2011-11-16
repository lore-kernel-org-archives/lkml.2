Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756688Ab1KPM6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:58:35 -0500
Received: from 8bytes.org ([88.198.83.132]:57406 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752376Ab1KPM6d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:58:33 -0500
Date: Wed, 16 Nov 2011 13:58:32 +0100
From: Joerg Roedel <joro@8bytes.org>
To: KyongHo Cho <pullip.cho@samsung.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        Avi Kivity <avi@redhat.com>, David Brown <davidb@codeaurora.org>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 0/2] Introduce iommu_commit() function
Message-ID: <20111116125832.GG11779@8bytes.org>
References: <1308843083-10442-1-git-send-email-joerg.roedel@amd.com> <BANLkTi=mfMfVVOmoZd49fqFnY_kq0hxzDw@mail.gmail.com> <20110629055102.GG29299@8bytes.org> <CAHQjnONaMVSN32nQQQ9KOy8_tHpi9Kc7YkQXY9+vZ0a4hFJuWA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHQjnONaMVSN32nQQQ9KOy8_tHpi9Kc7YkQXY9+vZ0a4hFJuWA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 16, 2011 at 11:00:56AM +0900, KyongHo Cho wrote:
> On Wed, Jun 29, 2011 at 2:51 PM, Joerg Roedel <joro@8bytes.org> wrote:

> In the 'next' branch of
> http://git.kernel.org/pub/scm/linux/kernel/git/joro/iommu.git,
> I found that iommu_commit() is removed.
> 
> Why is it removed?

It was never in the next-branch. It actually is in the master-branch,
but that happened accidentially :)
The reason is that there is not enough consensus about this interface
yet. This is also the reason I havn't pushed it upstream yet.


	Joerg
