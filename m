Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab1F2Qyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 12:54:52 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:57699 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754951Ab1F2Qyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 12:54:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Q+rE3RedpX1FniA4k2fPAJPZtnti2JmnOJo8QClVacYGwb9yEs2AZ1R1pbN6dmPCCz/8LqL4SMma/28chQ9BCEkvj6FhNiPYRIuMMTid+xqvUPXblUEY/7gdOY/7yNXH;
Date: Wed, 29 Jun 2011 09:54:36 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>, Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH 1/6] microblaze: move pci flag functions into
 asm-generic
Message-ID: <20110629095436.154cff94@jbarnes-desktop>
In-Reply-To: <1309366019-24379-2-git-send-email-robherring2@gmail.com>
References: <1309366019-24379-1-git-send-email-robherring2@gmail.com>
	<1309366019-24379-2-git-send-email-robherring2@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011 11:46:54 -0500
Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
> 
> Move pci_set_flags, pci_add_flags, and pci_has_flag into
> asm-generic/pci-bridge.h so other archs can use them.

Looks like something Ram may be able to re-use when adding resource
alloc behavior flags for the new bridge realloc code.

-- 
Jesse Barnes, Intel Open Source Technology Center
