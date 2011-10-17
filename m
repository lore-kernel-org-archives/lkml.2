Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752975Ab1JQSgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:36:48 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:19522 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab1JQSgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:36:46 -0400
Message-ID: <4E9C75B4.4050504@oracle.com>
Date: Mon, 17 Oct 2011 11:36:36 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 8/8] PCI, sys: only create rescan under /sys/.../pci/devices/...
 for pci bridges
References: <4E9A3092.4080309@oracle.com> <4E9A3436.3010704@oracle.com> <20111016023943.GA3787@suse.de> <4E9A6CCB.4060101@oracle.com> <20111016155517.GA6421@suse.de> <4E9B6A2F.1080706@oracle.com> <20111017014527.GA7322@suse.de>
In-Reply-To: <20111017014527.GA7322@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4E9C75BC.00A8:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2011 06:45 PM, Greg KH wrote:

> 
> This chunk is separate from the rest of the patch, right?
> 
> Please split this up into doing one thing per patch please.


just sent split versions out. please check it.

Thanks

Yinghai Lu
