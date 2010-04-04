Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab0DDJTm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 05:19:42 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39984 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752430Ab0DDJTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 05:19:36 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Chris Wright <chrisw@sous-sol.org>, Joerg Roedel <joerg.roedel@amd.com>,
       nhorman@redhat.com, nhorman@tuxdriver.com, kexec@lists.infradead.org,
       linux-kernel@vger.kernel.org, hbabu@us.ibm.com,
       iommu@lists.linux-foundation.org, vgoyal@redhat.com
Subject: Re: [PATCH 3/4] Revert "x86: disable IOMMUs on kernel crash"
References: <20100403012751.834020949@sous-sol.org>
	<20100403012820.229410717@sous-sol.org>
	<20100403172224.GO24846@8bytes.org> <m18w94l9c9.fsf@fess.ebiederm.org>
	<20100404084435.GT24846@8bytes.org> <m1fx3befxr.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sun, 04 Apr 2010 02:19:33 -0700
In-Reply-To: <m1fx3befxr.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Sun\, 04 Apr 2010 02\:16\:00 -0700")
Message-ID: <m1aatjefru.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: joro@8bytes.org, vgoyal@redhat.com, iommu@lists.linux-foundation.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org, kexec@lists.infradead.org, nhorman@tuxdriver.com, nhorman@redhat.com, joerg.roedel@amd.com, chrisw@sous-sol.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I guess I should add the place where I have serious test results for with
a gart is on 2.6.29.  Where there isn't that iommu shutdown and I don't have
problems with it.

So my experience is that touching the gart in machine_crash_shutdown is
unnecessary.

Eric
