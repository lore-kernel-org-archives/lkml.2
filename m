Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1GMWTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 18:19:24 -0400
Received: from trent.utfs.org ([194.246.123.103]:44343 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab1GMWTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 18:19:23 -0400
Date: Wed, 13 Jul 2011 15:19:20 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
cc: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Do not write to builddir in modules_install
In-Reply-To: <CAM_iQpUoLwar3wYUe-3i5tgSB4e9HF__QKSht2yxVYP_MmUqyQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.01.1107131518280.9183@trent.utfs.org>
References: <alpine.DEB.2.01.1107040242180.9183@trent.utfs.org> <1310470780-12330-1-git-send-email-mmarek@suse.cz> <CAM_iQpWfSFPcvDJCDwS9ADCEvw-6A3wyUh+kkhgqHOi2Zx_eSg@mail.gmail.com> <4E1D6396.1070200@suse.cz>
 <CAM_iQpUoLwar3wYUe-3i5tgSB4e9HF__QKSht2yxVYP_MmUqyQ@mail.gmail.com>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 at 19:22, Américo Wang wrote:
> >> Hmm, why not use $objtree/.tmp_depmod?
> >
> > That's how it was done before and it's broken. make modules_install is
> > usually ran as root and there is no guarantee that root has write access to
> > the build directory (it can be on nfs).
> 
> Hmm, this is reasonable. Then I am fine with this patch.

Tested here, works fine, even with a noexec-mounted $TMPDIR. Thanks!

Christian.
-- 
BOFH excuse #62:

need to wrap system in aluminum foil to fix problem
