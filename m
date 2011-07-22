Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1GVPoL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:44:11 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41061 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754693Ab1GVPoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:44:09 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=J9b5FWQy2sP1a0IM1oLFZJsSz2gKmVL6U2uCNiN7Q1mV2nknjX9d1GDjXfTOB/NoU7U3upVtz2V11TFN1+bKlBKWXVRPZVHP5aVFr8OBm0VkbLCQSEApDf+7OmF4qipY;
Date: Fri, 22 Jul 2011 08:44:01 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sshtylyov@ru.mvista.com, jbarnes@virtuousgeek.org, tglx@linutronix.de,
        davej@redhat.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/quirks] x86, quirks: Use pci_dev->revision
Message-ID: <20110722084401.3b1a3eb5@jbarnes-desktop>
In-Reply-To: <tip-38175051f8e79c5e9f65daab7200fd8d1fa4a912@git.kernel.org>
References: <201107111901.39281.sshtylyov@ru.mvista.com>
	<tip-38175051f8e79c5e9f65daab7200fd8d1fa4a912@git.kernel.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jul 2011 10:11:42 GMT
tip-bot for Sergei Shtylyov <sshtylyov@ru.mvista.com> wrote:

> Commit-ID:  38175051f8e79c5e9f65daab7200fd8d1fa4a912
> Gitweb:     http://git.kernel.org/tip/38175051f8e79c5e9f65daab7200fd8d1fa4a912
> Author:     Sergei Shtylyov <sshtylyov@ru.mvista.com>
> AuthorDate: Mon, 11 Jul 2011 19:01:38 +0400
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Thu, 21 Jul 2011 10:26:00 +0200
> 
> x86, quirks: Use pci_dev->revision
> 
> This code uses PCI_CLASS_REVISION instead of PCI_REVISION_ID, so
> it wasn't converted by commit 44c10138fd4bbc ("PCI: Change all
> drivers to use pci_device->revision") before being moved to arch/x86/...

applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
