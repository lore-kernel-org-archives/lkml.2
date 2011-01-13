Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757227Ab1AMQjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 11:39:00 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:40177 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757097Ab1AMQi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 11:38:58 -0500
Date: Thu, 13 Jan 2011 16:38:38 +0000
From: Matthew Garrett <mjg@redhat.com>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>, horms@verge.net.au,
        nhorman@tuxdriver.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, ebiederm@xmission.com,
        hpa@zytor.com, tglx@linutronix.de, vgoyal@redhat.com
Subject: Re: [PATCH v2][EFI] Run EFI in physical mode
Message-ID: <20110113163838.GA21289@srcf.ucam.org>
References: <F7CB3D97D99F33indou.takao@jp.fujitsu.com> <4D06E7FE.5000600@jp.fujitsu.com> <9CB9BB8ED64BAindou.takao@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9CB9BB8ED64BAindou.takao@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We're seeing issues with some Dell hardware when EFI is run in physical 
mode - it seems that Windows uses virtual mode, so the physical path is 
never exercised. I'm not sure that changing the default to physical is 
going to be possible without compatibility issues.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
