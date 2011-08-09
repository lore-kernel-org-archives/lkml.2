Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab1HIUGf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 16:06:35 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:48774 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442Ab1HIUGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 16:06:34 -0400
Subject: Re: [PATCH] hpsa: fix physical device lun and target numbering
 problem
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Stephen Cameron <stephenmcameron@gmail.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        mikem@beardog.cce.hp.com, thenzl@redhat.com, akpm@linux-foundation.org,
        axboe@kernel.dk
In-Reply-To: <CADzpL0TZfdQqoE-X-tN0SrsNSOvqJAsX8DzC46XpM_JihJY29w@mail.gmail.com>
References: <20110809131801.10649.44268.stgit@beardog.cce.hp.com>
	 <CADzpL0SnZ+t6RT5iU2Ne+HEdBO1n2K51WwqaVDHXPs1CDHGk2A@mail.gmail.com>
	 <CADzpL0TZfdQqoE-X-tN0SrsNSOvqJAsX8DzC46XpM_JihJY29w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 15:06:31 -0500
Message-ID: <1312920391.8648.6.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1+jejb.1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 14:58 -0500, Stephen Cameron wrote:
> On Tue, Aug 9, 2011 at 8:33 AM, Stephen Cameron
> <stephenmcameron@gmail.com> wrote:
> 
> > Despite the above patch, which I do think is correct, I can still get
> > a panic (on RHEL 6.1 with 2.6.31-rc1 kernel)
> 
> Er, I meant 3.1-rc1, not 2.6.31-rc1.

Do I take it from the fact that you cc'd stable that you want these
patches in the stable tree in spite of not adding the stable tag?

James


