Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874Ab1JIDQK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Oct 2011 23:16:10 -0400
Received: from lo.gmane.org ([80.91.229.12]:58775 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab1JIDQH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Oct 2011 23:16:07 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Alex Elsayed <eternaleye@gmail.com>
Subject: Re: A =?utf-8?b?UGx1bWJlcuKAmXM=?= Wish List for Linux
Date: Sun, 9 Oct 2011 03:15:51 +0000 (UTC)
Message-ID: <loom.20111009T050942-868@post.gmane.org>
References: <1317943022.1095.25.camel@mop> <20111007111231.6e11d18e@lxorguk.ukuu.org.uk> <CAPXgP12nDB2NX6hZabmkUZA9n0PZadi6Yv70LNms8fz9+MnVoA@mail.gmail.com> <20111007113820.3b8424a8@lxorguk.ukuu.org.uk> <CAPXgP11K4_eVn4_emEYVzCVUsm-BXDyStk7DnDmFpMTL=404Gg@mail.gmail.com> <CAE2SPAY=OzVKtgeO=QtT_73EKuJHBWMFkMLA==uG6UUk-pekvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: sea.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 50.46.216.106 (Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.3) Gecko/20100423 Ubuntu/10.04 (lucid) Firefox/3.6.3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bastien ROUCARIES <roucaries.bastien <at> gmail.com> writes:

> 
> On Fri, Oct 7, 2011 at 2:46 PM, Kay Sievers <kay.sievers <at> vrfy.org> wrote:
> > On Fri, Oct 7, 2011 at 12:38, Alan Cox <alan <at> lxorguk.ukuu.org.uk> wrote:
> >> On Fri, 7 Oct 2011 12:28:46 +0200 Kay Sievers <kay.sievers <at> vrfy.org>
wrote:
> >>> What do you mean would be ugly?
> >>
> >> I have an ext4fs. It supports every possible file name allowed by POSIX
> >> and SuS. What name are you going to use for your 'hidden directory' that
> >> won't clash with a real file ?
> >
> > Ah, no. The label on FAT (similar on NTFS) are 'magic entries' in the
> > root dir list, not a real file in the root dir.
> 
> Why not using a special xattr namespace ?
> 
> Bastien

All of you are completely misconstruing what was said. He was NOT suggesting
magic entries as an interface to change the label. He was noting that the FAT
filesystem IMPLEMENTS its labels as a magic entry, which cannot be safely
altered from userspace on a mounted FS, necessitating help from the kernel.

