Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583Ab2ILQ6k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 12:58:40 -0400
Received: from prod-mail-xrelay06.akamai.com ([96.6.114.98]:60824 "EHLO
	prod-mail-xrelay06.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760536Ab2ILQ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 12:58:09 -0400
Message-ID: <5050BF1F.1080503@akamai.com>
Date: Wed, 12 Sep 2012 11:58:07 -0500
From: Josh Hunt <johunt@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] amd64_edac: Memory size reported double on processor
 family 0Fh
References: <1347403947-20187-1-git-send-email-johunt@akamai.com> <504FC2E9.4010708@akamai.com> <20120912085140.GA12277@aftab.osrc.amd.com> <5050824B.9050006@akamai.com> <5050857F.5060207@akamai.com> <20120912153016.GA12103@aftab.osrc.amd.com> <5050AC2E.3050408@akamai.com> <20120912154943.GB12103@aftab.osrc.amd.com> <5050B708.5020308@akamai.com> <20120912164843.GC12103@aftab.osrc.amd.com>
In-Reply-To: <20120912164843.GC12103@aftab.osrc.amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 11:48 AM, Borislav Petkov wrote:
> Can I have /proc/cpuinfo and full dmesg with EDAC_DEBUG enabled from
> that machine please?
>
Actually my apologies. I was looking at the 3.0 code. This issue is 
fixed in the latest kernel.

Sorry for the noise on that.

Josh

