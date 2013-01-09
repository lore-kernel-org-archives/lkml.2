Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab3AIIQW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 03:16:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab3AIIQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 03:16:20 -0500
Message-ID: <50ED25E7.9010609@redhat.com>
Date: Wed, 09 Jan 2013 09:10:15 +0100
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Dmitry Torokhov <dtor@vmware.com>
CC: David Miller <davem@davemloft.net>, pv-drivers@vmware.com,
        gregkh@linuxfoundation.org, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [Pv-drivers] [PATCH 0/6] VSOCK for Linux upstreaming
References: <20130109002110.GB5296@kroah.com> <20130108.173056.1029788106028104571.davem@davemloft.net> <1683801.VNKd61ZM1Q@dtor-d630.eng.vmware.com> <20130108.174601.1788895671912734725.davem@davemloft.net> <20130109022204.GA22875@dtor-ws.eng.vmware.com>
In-Reply-To: <20130109022204.GA22875@dtor-ws.eng.vmware.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/13 03:22, Dmitry Torokhov wrote:
> On Tue, Jan 08, 2013 at 05:46:01PM -0800, David Miller wrote:
>> I'd much rather see a hypervisor neutral solution than a hypervisor
>> specific one which this certainly is.
> 
> Objectively speaking neither solution is hypervisor neutral as there are
> hypervisors that implement either VMCI or virtio or something else
> entirely.

Indeed.  vmchannel is tied to virtio like vsock is tied to vmci.

> Our position is that VSOCK feature set is more complete and that it
> should be possible to use transports other than VMCI for VSOCK traffic,
> should interested parties implement them,

Implementing other transports requires restructing vsock (and vmci)
first as the current vsock code is not a hypervisor neutral service.

cheers,
  Gerd
