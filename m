Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab2FROsl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:48:41 -0400
Received: from exht1.emulex.com ([138.239.113.183]:16696 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751220Ab2FROsj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:48:39 -0400
Message-ID: <4FDF3FB2.2060300@emulex.com>
Date: Mon, 18 Jun 2012 10:48:18 -0400
From: James Smart <james.smart@emulex.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Tobias Klausmann <tobias.johannes.klausmann@mni.thm.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Driver scsi/lpfc breaks build since 3.4.1
References: <4FDE71A4.2090807@mni.thm.de> <20120618012401.GA13192@kroah.com>
In-Reply-To: <20120618012401.GA13192@kroah.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fyi - the patch to lpfc to resolve this were submitted a while ago:
http://marc.info/?l=linux-scsi&m=133661285100503&w=2

-- james s


On 6/17/2012 9:24 PM, Greg KH wrote:
> On Mon, Jun 18, 2012 at 02:09:08AM +0200, Tobias Klausmann wrote:
>> Hello there,
>> since 3.4.1 the driver scsi/lpfc breaks my build for some unused variables:
>> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl’:
>> drivers/scsi/lpfc/lpfc_scsi.c:1900:11: error: unused variable ‘rc’
>> [-Werror=unused-variable]
>> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_bpl_prot’:
>> drivers/scsi/lpfc/lpfc_scsi.c:2037:11: error: unused variable ‘rc’
>> [-Werror=unused-variable]
>> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl’:
>> drivers/scsi/lpfc/lpfc_scsi.c:2256:11: error: unused variable ‘rc’
>> [-Werror=unused-variable]
>> drivers/scsi/lpfc/lpfc_scsi.c: In function ‘lpfc_bg_setup_sgl_prot’:
>> drivers/scsi/lpfc/lpfc_scsi.c:2386:11: error: unused variable ‘rc’
>> [-Werror=unused-variable]
>> cc1: all warnings being treated as errors
>>
>>  From the drivers makefile:
>> ccflags-y += -Werror <- this causes the bad behavior.
> As has been stated before, this ccflags setting is what needs to be
> fixed, not trying to fix up the warnings here (although that is a good
> goal overall.)
>
> Also, this isn't how to submit a patch to the stable kernel tree, please
> read Documentation/stable_kernel_rules.txt for how to properly do that.
>
> thanks,
>
> greg k-h


