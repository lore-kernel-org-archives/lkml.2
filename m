Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab2HQQME (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:12:04 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:51727 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2HQQL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:11:59 -0400
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, tytso@mit.edu,
        pbonzini@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi_debug: Fix off-by-one bug when unmapping region
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1345127925-32042-1-git-send-email-lczerner@redhat.com>
Date: Fri, 17 Aug 2012 12:11:50 -0400
In-Reply-To: <1345127925-32042-1-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Thu, 16 Aug 2012 16:38:45 +0200")
Message-ID: <yq1d32ph515.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Lukas" == Lukas Czerner <lczerner@redhat.com> writes:

Lukas> Currently it is possible to unmap one more block than user
Lukas> requested to due to the off-by-one error in unmap_region(). This
Lukas> is probably due to the fact that the end variable despite its
Lukas> name actually points to the last block to unmap + 1. However in
Lukas> the condition it is handled as the last block of the region to
Lukas> unmap.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
