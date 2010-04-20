Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753682Ab0DTGnf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 02:43:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:57779 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab0DTGnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 02:43:33 -0400
X-Greylist: delayed 42657 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Apr 2010 02:43:33 EDT
Message-ID: <4BCD4C8D.7070805@oracle.com>
Date: Mon, 19 Apr 2010 23:41:17 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Peter Henriksson <peter.henriksson@gmail.com>
CC: Yinghai <yinghai.lu@oracle.com>, Clemens Ladisch <clemens@ladisch.de>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-pci@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [regression, bisected] Xonar DX invalid PCI I/O range since 
 977d17bb174
References: <4BCBFE89.9070401@ladisch.de>	 <o2gf046f1351004190044h6c3f6536ga916d2fa047f3fe7@mail.gmail.com>	 <4BCC0F10.3070208@ladisch.de>	 <l2sf046f1351004190142ocb2e5f1fyc0e892489caa76a3@mail.gmail.com>	 <4BCCA5FD.6060002@oracle.com> <1271706161.2505.6.camel@darwin.lan>
In-Reply-To: <1271706161.2505.6.camel@darwin.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090205.4BCD4D10.008D:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2010 12:42 PM, Peter Henriksson wrote:
> On Mon, 2010-04-19 at 11:50 -0700, Yinghai wrote:
>> please try:
>>
>> [PATCH] pci: disable pci trying to reallocate pci bridge by default.
>>
>> it broken Linus's Nouveau
>>
> 
> Not sure why but I had to use some spit and glue to get it to apply.
> Other than that, works for me, thanks.

please post bootlog without patch.

compile CONFIG_PCI_DEBUG=y and boot with "debug" in command line

YH
