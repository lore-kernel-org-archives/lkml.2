Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab1EEQuI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 12:50:08 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:57973 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755364Ab1EEQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 12:50:06 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 0/4] x86, MCE, AMD: Hardware MCE injection
Date: Thu,  5 May 2011 18:49:32 +0200
Message-Id: <1304614176-7063-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Hi,

only small changes from the last submission
(http://lkml.org/lkml/2011/4/15/171) so that we can have valid
MCG_STATUS values and don't choke on severity sanity checking.

@Ingo: I don't care which way 1/4 takes upstream so I'm fine with either
you ACKing and I send it to Linus in the next merge window or picking it
up.


Thanks.
