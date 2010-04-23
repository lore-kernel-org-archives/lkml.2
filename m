Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757508Ab0DWNwT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:52:19 -0400
Received: from cantor.suse.de ([195.135.220.2]:58742 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab0DWNwR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:52:17 -0400
Subject: Re: [PATCH 5/8] KVM: X86: Add callback to let modules decide over some supported cpuid bits
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1271932394-13968-6-git-send-email-joerg.roedel@amd.com>
Date: Fri, 23 Apr 2010 15:52:14 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <8750FE80-57D8-4D59-AC4A-D04B04E8707B@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com> <1271932394-13968-6-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 22.04.2010, at 12:33, Joerg Roedel wrote:

> This patch adds the get_supported_cpuid callback to
> kvm_x86_ops. It will be used in do_cpuid_ent to delegate the
> decission about some supported cpuid bits to the
> architecture modules.
> 
> Cc: stable@kernel.org

Please don't CC stable. There is a KVM stable tag now, so every stable submission goes through Avi/Marcelo.


Alex

