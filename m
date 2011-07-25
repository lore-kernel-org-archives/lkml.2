Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab1GYH1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:27:40 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:39752 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1GYH1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:27:30 -0400
Subject: Re: linux-next: build failure after merge of the iscsi-target tree
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        target-devel <target-devel@vger.kernel.org>,
        Mike Christie <michaelc@cs.wisc.edu>
In-Reply-To: <20110725134509.3a1c59c07eb7a5608a8712f7@canb.auug.org.au>
References: <20110725134509.3a1c59c07eb7a5608a8712f7@canb.auug.org.au>
Content-Type: text/plain
Date: Mon, 25 Jul 2011 00:18:09 -0700
Message-Id: <1311578289.17766.17.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 13:45 +1000, Stephen Rothwell wrote:
> Hi Nicholas,
> 

Hi Stephen,

> After merging the iscsi-target tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/scsi/bnx2i/bnx2i_iscsi.c: In function 'bnx2i_task_xmit':
> drivers/scsi/bnx2i/bnx2i_iscsi.c:1233:20: error: dereferencing pointer to incomplete type
> 
> Caused by commit 5dd46e6560d4 ("iscsi: Resolve iscsi_proto.h naming
> conflicts with drivers/target/iscsi").
> 
> I have dropped the iscsi-target tree for today.

My apologies for missing this one..

Just fixed the missing struct iscsi_cmd -> struct iscsi_scsi_req
conversion in bnx2i_task_xmit(), and rebased -> pushed into
target-pending.git/for-next.

Thank you,

--nab

