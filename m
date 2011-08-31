Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1HaFsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 01:48:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3121 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752758Ab1HaFsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 01:48:09 -0400
Message-ID: <4E5DCB14.3030009@redhat.com>
Date: Wed, 31 Aug 2011 08:48:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Richard Kuo <rkuo@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-hexagon@vger.kernel.org
Subject: Re: [patch 00/36] Hexagon: Add support for Qualcomm Hexagon architecture
References: <20110817163457.878854582@codeaurora.org>
In-Reply-To: <20110817163457.878854582@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/17/2011 07:34 PM, Richard Kuo wrote:
> The following patch set is intended to add support for the Qualcomm Hexagon
> architecture to the Linux kernel.
>
> The Hexagon architecture is designed to deliver performance with low power
> over a variety of applications.  It has features such as multithreading,
> privilege levels, VLIW, and instructions geared toward efficient signal
> processing.  The port of Linux for Hexagon runs under a hypervisor layer.
>

Have you considered porting kvm to hexagon, so Linux can be used as the 
hypervisor as well?




-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

