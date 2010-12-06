Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0LFQNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:13:23 -0500
Received: from goliath.siemens.de ([192.35.17.28]:20873 "EHLO
	goliath.siemens.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab0LFQNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:13:22 -0500
Message-ID: <4CFD0B9D.6020809@siemens.com>
Date: Mon, 06 Dec 2010 17:13:17 +0100
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: Re: Roadmap for KVM support on Tile?
References: <4CFCD363.7060803@siemens.com> <4CFD0857.8050205@tilera.com>
In-Reply-To: <4CFD0857.8050205@tilera.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 06.12.2010 16:59, Chris Metcalf wrote:
> On 12/6/2010 7:13 AM, Jan Kiszka wrote:
>> Hi Chris,
>>
>> as I'm already running around, telling people that Tile might be the
>> next arch to gain KVM support, I wanted to back this derived [1]
>> information with some more details. Can you share some of your plans
>> regarding this, either officially (LKML, kvm-devel) or yet privately?
>>  - What will be the level of support in the first version and long-term
>>    (CPU virtualization + I/O emulation, also I/O virtualization/
>>    pass-though)?
>>  - What use cases do you target, and why do you plan to use KVM for
>>    them?
>>  - What use cases may not fit a KVM-based approach?
>>
>> The background of this questionnaire is not (yet) a concrete project
>> based on a Tile processor and KVM. Right now I'm primarily promoting KVM
>> for use cases beyond classic x86 server scenarios, both in-house as well
>> as in the community.
>>
>> TiA!
>>
>> Best regards,
>> Jan Kiszka
>>
>> [1] http://permalink.gmane.org/gmane.linux.kernel/1048568
> 
> We already have a hypervisor that is used for Tile, which allows us to do
> client isolation and spatial multiplexing (i.e. splitting the cores among
> different supervisors), and smooths over some of the more nitty-gritty
> hardware issues to present an easier API to the client supervisor, e.g.
> Linux.  The supervisor is paravirtualized, i.e. aware of the hypervisor API
> for page-table management and I/O access.
> 
> But moving forward there is some appeal to using a standard virtualization
> technology, and we picked KVM as the target that seemed best for us to
> support.  Some of the things this will facilitate for us include dynamic
> reconfiguration of supervisor domains, sharing I/O devices between
> supervisors, providing virtual devices to supervisors, virtual machine
> migration/snapshots, etc.  And, we'd like to support a standard management
> interface such as the KVM interface, so our customers don't have to learn
> how to manage the Tilera-specific hypervisor software.
> 
> None of this is committed to any particular release schedule yet, but this
> is the direction we are currently planning to head.
> 

Thanks for the information! Sound thrilling, looking forward seeing this
materializing.

Jan

-- 
Siemens AG, Corporate Technology, CT T DE IT 1
Corporate Competence Center Embedded Linux
