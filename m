Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2KMHdS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 02:33:18 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:51342 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753069Ab2KMHdQ convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Tue, 13 Nov 2012 02:33:16 -0500
Message-Id: <50A205C902000078000A7ECF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Tue, 13 Nov 2012 07:33:13 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Andrew Cooks" <acooks@gmail.com>,
        "Bjorn Helgaas (supporter:PCI SUBSYSTEM)" <bhelgaas@google.com>
Cc: "open list" <linux-kernel@vger.kernel.org>,
        "open list:PCI SUBSYSTEM" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] Add missing license for ioapic module.
References: <1352781547-9433-1-git-send-email-acooks@gmail.com>
In-Reply-To: <1352781547-9433-1-git-send-email-acooks@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.11.12 at 05:39, Andrew Cooks <acooks@gmail.com> wrote:
> config PCI_IOAPIC turned into a tristate in commit 
> b95a7bd700466c10fda84acbd33f70cf66ec91ce, but no module license is specified. 
> This adds the missing module license.
> 
> Signed-off-by: Andrew Cooks <acooks@gmail.com>

Acked-by: Jan Beulich <jbeulich@suse.com>

> ---
>  drivers/pci/ioapic.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/pci/ioapic.c b/drivers/pci/ioapic.c
> index 205af8d..22436f7 100644
> --- a/drivers/pci/ioapic.c
> +++ b/drivers/pci/ioapic.c
> @@ -125,3 +125,5 @@ static void __exit ioapic_exit(void)
>  
>  module_init(ioapic_init);
>  module_exit(ioapic_exit);
> +
> +MODULE_LICENSE("GPL");
> -- 
> 1.7.1



