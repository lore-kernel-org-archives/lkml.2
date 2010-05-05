Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934066Ab0EECog (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 22:44:36 -0400
Received: from mail.vyatta.com ([76.74.103.46]:53928 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756663Ab0EECoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 22:44:34 -0400
Date: Tue, 4 May 2010 19:44:19 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Pankaj Thakkar <pthakkar@vmware.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Shreyas Bhatewara <sbhatewara@vmware.com>
Subject: Re: RFC: Network Plugin Architecture (NPA) for vmxnet3
Message-ID: <20100504194419.2ce32117@nehalam>
In-Reply-To: <20100505001857.GQ8323@vmware.com>
References: <20100504230225.GP8323@vmware.com>
	<20100504170531.1e7122da@nehalam>
	<20100505001857.GQ8323@vmware.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010 17:18:57 -0700
Pankaj Thakkar <pthakkar@vmware.com> wrote:

> The purpose of this email is to introduce the architecture and the design principles. The overall project involves more than just changes to vmxnet3 driver and hence we though an overview email would be better. Once people agree to the design in general we intend to provide the code changes to the vmxnet3 driver.

As Dave said, we care more about what the implementation looks like than the high level
goals of the design. I think we all agree that better management of virtualized devices
is necessary, the problem is that their are so many of them (vmware, xen, HV, Xen), 
and vendors seem to to lean on their own specific implementation of a offloading, 
which makes a general solution more difficult. Please, Please solve this cleanly.

The little things like API's and locking semantics and handling of dynamic versus
static control can make a good design in principle fall apart when someone does a bad
job of implementing them.

Lastly, projects that have had multiple people involved for long periods of time
in the dark often end up building a legacy mentality "but we convinced vendor XXX to include it
in their Enterprise version 666" and require lots of "retraining" before the code
becomes acceptable.

-- 
