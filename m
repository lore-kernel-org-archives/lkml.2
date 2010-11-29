Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646Ab0K2Pqp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 10:46:45 -0500
Received: from e24smtp02.br.ibm.com ([32.104.18.86]:52239 "EHLO
	e24smtp02.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0K2Pqo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 10:46:44 -0500
Message-ID: <4CF3CADB.7060400@linux.vnet.ibm.com>
Date: Mon, 29 Nov 2010 13:46:35 -0200
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Jiri Kosina <jkosina@suse.cz>, Debora Velarde <debora@linux.vnet.ibm.com>,
        Marcel Selhorst <m.selhorst@sirrix.com>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, "Rafael J. Wysocki" <rjw@suse.com>,
        jmorris@namei.org
Subject: Re: [REGRESSION] Suspend fails because of TPM modules
References: <alpine.LNX.2.00.1011291554570.981@pobox.suse.cz> <alpine.LNX.2.00.1011291614060.981@pobox.suse.cz> <4CF3C547.6020302@linux.vnet.ibm.com> <alpine.LNX.2.00.1011291625120.981@pobox.suse.cz> <20101129153224.GA10173@srcf.ucam.org>
In-Reply-To: <20101129153224.GA10173@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2010 01:32 PM, Matthew Garrett wrote:
> On Mon, Nov 29, 2010 at 04:26:19PM +0100, Jiri Kosina wrote:
>
>> Any ideas why other kernels were OK (.34) and didn't require this quirk on
>> my machine at all?
> We previously ignored devices that had an invalid PNP ID in _HID,
> whereas now we still pay attention to them if they have a valid ID in
> _CID.
>
Yeah, and to make sense with my previous post, the workaround I 
mentioned depended on a module option given that the device couldn't be 
detected without having to send it commands.

Rajiv
