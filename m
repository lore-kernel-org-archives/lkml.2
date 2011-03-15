Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1COXDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:03:42 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39376 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab1COXDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:03:41 -0400
Subject: Re: [RFC-v2 07/12] iscsi-target: Add CHAP Authentication support
	using libcrypto
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20110315102404.GB24496@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-8-git-send-email-nab@linux-iscsi.org>
	 <20110315102404.GB24496@lst.de>
Content-Type: text/plain
Date: Tue, 15 Mar 2011 15:56:37 -0700
Message-Id: <1300229797.28255.317.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 11:24 +0100, Christoph Hellwig wrote:
> On Mon, Mar 14, 2011 at 04:57:04AM -0700, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > This patch adds support for libcrypto md5 based iSCSI CHAP authentication
> > support for iscsi_target_mod.  This includes support for mutual and one-way
> > NodeACL authentication for SessionType=Normal and SessionType=Discovery
> > via /sys/kernel/config/target/iscsi.
> > 
> > Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
> > ---
> >  drivers/target/iscsi/iscsi_auth_chap.c |  502 ++++++++++++++++++++++++++++++++
> >  drivers/target/iscsi/iscsi_auth_chap.h |   33 ++
> >  2 files changed, 535 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/target/iscsi/iscsi_auth_chap.c
> >  create mode 100644 drivers/target/iscsi/iscsi_auth_chap.h
> 
> Why aren't these files named iscsi_target_* like most others?  If you prefix
> all files in a module please do it consistently, or alternatively just
> drop the prefix altogether.
> 

This where shared amounst initiator code at one point..  Renaming to
iscsi_target_auth now.

Thanks,

--nab

