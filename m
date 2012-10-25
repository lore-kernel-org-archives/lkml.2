Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab2JYLP3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 07:15:29 -0400
Received: from caiajhbdcahe.dreamhost.com ([208.97.132.74]:60242 "EHLO
	homiemail-a10.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753681Ab2JYLP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 07:15:28 -0400
Message-ID: <1351163725.2513.14.camel@offbook>
Subject: [PATCH RESEND 0/3] partitions: efi: tighten gpt header integrity
 checks
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Jens Axboe <axboe@kernel.dk>, Matt Domsch <Matt_Domsch@dell.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Date: Thu, 25 Oct 2012 13:15:25 +0200
Organization: GNU
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

This is a resend of a patchset sent in early September to harden GPT header checks.

 partitions: efi: check minimum header size
 partitions: efi: verify header is outside usable area
 partitions: efi: compare first and last usable LBAs

 block/partitions/efi.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)


Thanks,
Davidlohr


