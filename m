Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757543Ab0DWN6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:58:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757414Ab0DWN6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:58:19 -0400
Subject: Re: [PATCH 8/8] KVM: SVM: Handle MCE intercepts always on host level
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1271932394-13968-9-git-send-email-joerg.roedel@amd.com>
Date: Fri, 23 Apr 2010 15:58:18 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <2316FEB4-9D50-436E-B29F-C6B43970AC9A@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-9-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.04.2010, at 12:33, Joerg Roedel wrote:

> This patch prevents MCE intercepts from being propagated
> into the L1 guest if they happened in an L2 guest.

Good catch. How did you stumble over this?

Ack.

Alex

