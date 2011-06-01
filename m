Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756Ab1FAOga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 10:36:30 -0400
Received: from ns5.dns-guards.com ([41.203.20.164]:52606 "EHLO
	velocity.dns-guards.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757656Ab1FAOgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 10:36:25 -0400
Message-ID: <sig.21336dc9dc.4DE64E63.4050902@radicalsystems.co.za>
Date: Wed, 01 Jun 2011 16:36:19 +0200
From: Jan Zwiegers <jan@radicalsystems.co.za>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-GB; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Xianghua Xiao <xiaoxianghua@gmail.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: PCI BAR1 Unassigned
References: <4DD5452F.9050108@radicalsystems.co.za> <BANLkTi=g=fKaXF4uwwjLSX-R+pk0FUa6OQ@mail.gmail.com> <sig.512079e334.4DD57D44.50009@radicalsystems.co.za> <BANLkTikHQNQdWoDS2dXUC9gTPWvtmUM=yA@mail.gmail.com> <sig.51214cae32.4DD61B48.8010601@radicalsystems.co.za> <BANLkTi=jTKp9+_KDmTxYfGXe6Ln02GLmDA@mail.gmail.com> <sig.6125c0d242.4DDB86FE.5090809@radicalsystems.co.za> <BANLkTi=FTkPCVEMdKBgwg61hKDvgpJ6oRA@mail.gmail.com> <BANLkTikm0fkii_SyoJ4W1j+nZD-ErS+o-A@mail.gmail.com> <BANLkTi=SGVoEK0YxeRVGvh34FTg3=qX0SA@mail.gmail.com>
In-Reply-To: <BANLkTi=SGVoEK0YxeRVGvh34FTg3=qX0SA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Assp-ID: velocity.dns-guards.com ()
X-Assp-Version: 1.7.1.3(1.0.2)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - velocity.dns-guards.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - radicalsystems.co.za
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-05-31 05:02 AM, Bjorn Helgaas wrote:
> On Thu, May 26, 2011 at 2:38 PM, Bjorn Helgaas<bhelgaas@google.com>  wrote:
>> Jan, would you mind testing the attached patch?  This is against
>> current upstream, but I think it will apply without much trouble to
>> 2.6.35; I don't think there have been many changes in that area.
>> Thanks.
>
> Hi Jan,
>
> If you haven't tested the patch yet, can you substitute this one?  It
> should be functionally equivalent, but I did tweak it a bit.
>
> Bjorn
Yes, I'll test this one.
Not a problem!
