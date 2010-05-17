Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab0EQWfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:35:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:29018 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756245Ab0EQWfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:35:03 -0400
Message-ID: <4BF1C3F1.3000904@oracle.com>
Date: Mon, 17 May 2010 15:32:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Linux PCI <linux-pci@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Matthew Garrett <mjg@redhat.com>, Greg Kroah-Hartman <gregkh@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [update] Re: [RFC][PATCH] PM / PCI: Update PCI power management
 documentation
References: <201005162149.31770.rjw@sisk.pl> <4BF0B1C5.4060601@oracle.com> <201005180023.24885.rjw@sisk.pl>
In-Reply-To: <201005180023.24885.rjw@sisk.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BF1C433.014E:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/10 15:23, Rafael J. Wysocki wrote:
> ---
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / PCI: Update PCI power management documentation
> 
> The PCI power management document, Documentation/power/pci.txt, is
> outdated and partially inaccurate.  It also is missing some important
> information about the power management of PCI device.  Rewrite it to
> make it more up to date and more complete.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Thanks for the updates.
Reviewed-by: Randy Dunlap <randy.dunlap@oracle.com>


> ---
>  Documentation/power/pci.txt | 1308 ++++++++++++++++++++++++++++++++++----------
>  1 file changed, 1017 insertions(+), 291 deletions(-)
> 
> Index: linux-2.6/Documentation/power/pci.txt
> ===================================================================
> --- linux-2.6.orig/Documentation/power/pci.txt
> +++ linux-2.6/Documentation/power/pci.txt


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
