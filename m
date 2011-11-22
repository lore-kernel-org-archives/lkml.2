Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758533Ab1KVLnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:43:05 -0500
Received: from nm13-vm4.bullet.mail.ne1.yahoo.com ([98.138.91.173]:26548 "HELO
	nm13-vm4.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758514Ab1KVLnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:43:01 -0500
X-Yahoo-Newman-Id: 330976.81571.bm@smtp112.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: glF4P18VM1kpBfW5fEebn0goBaQxkYqH1vQQeU7sU1E89Ei
 RVfsoNsFxTjxo03BS70HpHzSKdnPFGPJUFf4ZxLK_NrOqhZ8EFJS5BFPr8YJ
 m4_FX1u8gC5deimTIh2aS9Ix6PVmjZ5rEGuiWdKimtMGGiRWWYC4vT248F7C
 my_RE2_NfJKRIZ9coHQ_NB2ejDlg60WTv0GjbpCC1JQUKLMQmSMnkstPSc8j
 eD6IwE3VnIdj0F6PfvYa1gmiBFREI2CZfcHZHgMCkmb_8Dmfa0Qn_ok9.9q7
 C44kxguZIbXkb6.bXijTWVixYF4PSBeuDe3M9eLJFl93JcwmoqhgedWWPb7P
 7BiT.iskbkd1EE.icv03fJ0XbZRxRHjbI7FiETZyHI08FoP0-
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Tue, 22 Nov 2011 06:42:49 -0500
From: Andrew Watts <akwatts@ymail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [OOPS]: Kernel 3.1 (ext3?)
Message-ID: <20111122114247.GB20081@zeus>
References: <20111110132929.GA11417@zeus>
 <20111114195352.GB17328@quack.suse.cz>
 <alpine.DEB.2.00.1111151004050.22502@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1111151004050.22502@router.home>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 10:05:25AM -0600, Christoph Lameter wrote:
> On Mon, 14 Nov 2011, Jan Kara wrote:
> 
> > On Thu 10-11-11 08:29:37, Andrew Watts wrote:
> > > I had the following kernel panic today on 3.1 (machine was compiling code
> > > unattended). It would appear to be a bug/regression introduced sometime
> > > between 2.6.39.4 and 3.1.
> >   Hmm, the report is missing a line (top one) saying why the kernel
> > actually crashed. Can you add that?
> >
> >   Also it seems you are using SLUB allocator, right? This seems like a
> > problem there so adding some CCs.
> 
> Likely some data corruption. Enable slub debugging by passing
> 
> slub_debug
> 
> on the kernel commandline please to get some information as to where and
> when this happens.
> 

Hi Christoph.

Thank you for your reply. I'll enable slub debugging and post anything of
interest.

~ Andy

