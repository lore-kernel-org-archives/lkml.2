Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1GVPoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:44:16 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:52165 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754862Ab1GVPoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:44:14 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=CEp2NIZgCqhhx9Lzjzu7xEv6wwgnDrhMJCn78h3zGLO5alIUqyvCo7zIxbtqpInwDbGjPfjpNrWDXvty1D2GDpysIrPKMVsavZhwMKF2PhMdJLHleTWSJOfDImgGBj+O;
Date: Fri, 22 Jul 2011 08:44:08 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Chris Wright <chrisw@sous-sol.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Don Dutile <ddutile@redhat.com>
Subject: Re: [PATCH resend] pci: ARI is a PCIe v2 feature
Message-ID: <20110722084408.7be2e9bc@jbarnes-desktop>
In-Reply-To: <20110713171433.GU15844@sequoia.sous-sol.org>
References: <20110713171433.GU15844@sequoia.sous-sol.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011 10:14:33 -0700
Chris Wright <chrisw@sous-sol.org> wrote:

> The function pci_enable_ari() may mistakenly set the downstream port
> of a v1 PCIe switch in ARI Forwarding mode.  This is a PCIe v2 feature,
> and with an SR-IOV device on that switch port believing the switch above
> is ARI capable it may attempt to use functions 8-255, translating into
> invalid (non-zero) device numbers for that bus.  This has been seen
> to cause Completion Timeouts and general misbehaviour including hangs
> and panics.

Applied, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
