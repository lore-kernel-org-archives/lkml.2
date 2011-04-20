Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1DTPNz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 11:13:55 -0400
Received: from oproxy2-pub.bluehost.com ([67.222.39.60]:46890 "HELO
	oproxy2-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755158Ab1DTPNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 11:13:53 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Sv90AxmeOeh6egwjCx7X5df9DBgYb3kj1MnNPkoJy/HXV5AH7FTfBndShXET0kCbNJDITfWC9juTi0/9tC4rx9/cX8/nTrgctjschkKV9pu124VyqTIFg+cyc3oytJZi;
Date: Wed, 20 Apr 2011 08:13:48 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        khali@linux-fr.org
Subject: Re: [PATCH 2.6.39-rc3] lpc: irq and pci_ids patch for Intel Panther
 Point DeviceIDs
Message-ID: <20110420081348.3f1f8c28@jbarnes-desktop>
In-Reply-To: <201104191635.16141.seth.heasley@intel.com>
References: <201104191635.16141.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 16:35:15 -0700
Seth Heasley <seth.heasley@intel.com> wrote:

> This patch adds the LPC Controller DeviceIDs for the Intel Panther Point PCH.
> 
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
