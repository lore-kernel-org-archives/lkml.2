Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab0DWNnq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 09:43:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:58450 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab0DWNno convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 09:43:44 -0400
Subject: Re: [PATCH 0/8] More fixes for nested svm
Mime-Version: 1.0 (Apple Message framework v1078)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
Date: Fri, 23 Apr 2010 15:43:41 +0200
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <925EC0BC-2BAD-403D-91E0-1FDCEF21D172@suse.de>
References: <1271932394-13968-1-git-send-email-joerg.roedel@amd.com>
To: Joerg Roedel <joerg.roedel@amd.com>
X-Mailer: Apple Mail (2.1078)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Joerg,

On 22.04.2010, at 12:33, Joerg Roedel wrote:

> Hi Avi, Marcelo,
> 
> here is another set of nested svm fixes. They fix NMI code to make UP Hyper-V
> root domain booting. The patches also add better handling for nested entry
> failures and mce intercepts.
> Also in this patchset are the fixes for the supported cpuid reporting for svm
> features. These patches were taken from the nested-npt patchset and slightly
> modified. These patches are also marked for -stable backporting.
> The probably most important fix is about exception reinjection. This didn't
> work reliably before and is fixed with the patch in this series now. This fix
> also touches common x86 code but that should be ok because it could be reused
> by nested-vmx later.
> Please review and give comments (or apply ;-).


Nice work. Please remember to keep me CC'ed when posting nested SVM patches.


Alex

