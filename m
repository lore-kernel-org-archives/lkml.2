Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759078Ab0LNKIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:08:32 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:44892 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759056Ab0LNKIa convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:6:1>);
	Tue, 14 Dec 2010 05:08:30 -0500
Message-Id: <4D0750250200007800027C67@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Tue, 14 Dec 2010 10:08:21 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <xen-devel@lists.xensource.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "Konrad Rzeszutek Wilk" <konrad@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 9/9] xen/xen-pciback: Swap over to
	 DEFINE_PCI_DEVICE_TABLE
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
 <1292263303-31680-10-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1292263303-31680-10-git-send-email-konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 13.12.10 at 19:01, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  drivers/xen/pciback/pci_stub.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/xen/pciback/pci_stub.c b/drivers/xen/pciback/pci_stub.c
> index c8f6f29..09dd60c 100644
> --- a/drivers/xen/pciback/pci_stub.c
> +++ b/drivers/xen/pciback/pci_stub.c
> @@ -497,7 +497,7 @@ static void pcistub_remove(struct pci_dev *dev)
>  	}
>  }
>  
> -static const struct pci_device_id pcistub_ids[] = {
> +DEFINE_PCI_DEVICE_TABLE(pcistub_ids) = {
>  	{
>  	 .vendor = PCI_ANY_ID,
>  	 .device = PCI_ANY_ID,


You shouldn't drop "static" here.

Jan

