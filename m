Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965596Ab0GPNTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 09:19:45 -0400
Received: from 8bytes.org ([88.198.83.132]:39289 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965247Ab0GPNTo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 09:19:44 -0400
Date: Fri, 16 Jul 2010 15:19:07 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Zachary Amsden <zamsden@redhat.com>
Cc: KVM <kvm@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Glauber Costa <glommer@redhat.com>,
        Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: KVM timekeeping fixes, V2
Message-ID: <20100716131907.GJ23755@8bytes.org>
References: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278987938-23873-1-git-send-email-zamsden@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 04:25:20PM -1000, Zachary Amsden wrote:
> Discovered brammage in patches due to unresolved merge.
> Also, had to move 09/18 past 08/18 to resolve compile issue.

Have you tested this patchset with Nested SVM? We had TSC handling
related bugs there in the past and should make sure to keep it working.

	Joerg

