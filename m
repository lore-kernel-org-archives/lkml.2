Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab1DUIdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:33:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab1DUIdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:33:01 -0400
Message-ID: <4DAFEBB7.9090909@redhat.com>
Date: Thu, 21 Apr 2011 11:32:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, jan.kiszka@siemens.com,
        jbarnes@virtuousgeek.org
Subject: Re: [PATCH v3 3/3] KVM: Use pci_store/load_saved_state() around VM
 device	usage
References: <20110420202523.3189.31306.stgit@s20.home> <20110420203146.3189.47203.stgit@s20.home>
In-Reply-To: <20110420203146.3189.47203.stgit@s20.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2011 11:31 PM, Alex Williamson wrote:
> Store the device saved state so that we can reload the device back
> to the original state when it's unassigned.  This has the benefit
> that the state survives across pci_reset_function() calls via
> the PCI sysfs reset interface while the VM is using the device.

Acked-by: Avi Kivity <avi@redhat.com>

-- 
error compiling committee.c: too many arguments to function

