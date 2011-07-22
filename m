Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1GVPxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 11:53:14 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58837 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754489Ab1GVPxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 11:53:13 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=hIxRq+UY+V0p/F02RHeFD7o+uSTzAOpsNVRoY1tUhEKTMb/a/88GcyH0wGBGjslXlIIK3nanQBvLSbdZgId7SgVM7nkkOPH/GPYa/Fb9s8qRsJ8ZIJgwoBHjbpdPEm2r;
Date: Fri, 22 Jul 2011 08:53:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, Michal Simek <monstr@monstr.eu>, nico@fluxnic.net,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 4/6] ARM: pci: make pcibios_assign_all_busses use
 pci_has_flag
Message-ID: <20110722085305.2f5b6160@jbarnes-desktop>
In-Reply-To: <1310489612-8625-5-git-send-email-robherring2@gmail.com>
References: <1310489612-8625-1-git-send-email-robherring2@gmail.com>
	<1310489612-8625-5-git-send-email-robherring2@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jul 2011 11:53:30 -0500
Rob Herring <robherring2@gmail.com> wrote:

> From: Rob Herring <rob.herring@calxeda.com>
> 
> Convert pcibios_assign_all_busses from a define to inline so platforms can
> control this setting.
> 
> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> ---

Looks fine to me.  Assuming it's not already upstream... :)

Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>

-- 
Jesse Barnes, Intel Open Source Technology Center
