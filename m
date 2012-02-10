Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2BJHY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 02:24:28 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:51409 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab2BJHY1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 02:24:27 -0500
Message-ID: <4F34C622.3060905@oracle.com>
Date: Fri, 10 Feb 2012 15:24:18 +0800
From: liang tang <liang.tang@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.23) Gecko/20110920 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, konrad.wilk@oracle.com
Subject: Re: [PATCH 3/5] EFI: add efi driver for Xen efi
References: <1328758250-23989-1-git-send-email-liang.tang@oracle.com> <1328758401-24258-1-git-send-email-liang.tang@oracle.com> <20120209194723.GA8622@srcf.ucam.org>
In-Reply-To: <20120209194723.GA8622@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F34C626.0075,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,Matthew
the xen efi call need to use hypercall. that is different from the 
generic efi code. do you any idea about that. thanks!


On 2012-2-10 3:47, Matthew Garrett wrote:
> Hm. Is there absolutely no way to do this by replacing efi_call_*? It'd
> really be nice to avoid yet another set of duplicate functions here -
> the ia64/x86 situation is already bad enough. Ideally this would be
> sufficiently generic that arm can also plug into it.
>
