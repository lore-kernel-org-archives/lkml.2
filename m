Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754056Ab2HRWNC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 18:13:02 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42271 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab2HRWM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 18:12:57 -0400
X-Sasl-enc: 5YcTzdaOeEd9V1ay4Xod/3vfBu595pZmHCpU+qEhmZv0 1345327976
Date: Sat, 18 Aug 2012 19:12:52 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Fenghua Yu <fenghua.yu@intel.com>
Cc: H Peter Anvin <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Asit K Mallick <asit.k.mallick@intel.com>,
        Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Subject: Re: [PATCH 02/11] x86/lib/cpio.c: Find cpio data by its file name
Message-ID: <20120818221252.GA32120@khazad-dum.debian.net>
References: <1345277729-8399-1-git-send-email-fenghua.yu@intel.com>
 <1345277729-8399-3-git-send-email-fenghua.yu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345277729-8399-3-git-send-email-fenghua.yu@intel.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2012, Fenghua Yu wrote:
> Given a file's name, find its starting point in a cpio formated area. This will
> be used to find microcode in combined initrd image. But this function is
> generic and could be used in other places.

Shouldn't this (very useful) feature get its own documentation in
Documentation/ ?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
