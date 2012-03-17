Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030881Ab2CQNM7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 09:12:59 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:59502 "EHLO
	homiemail-a93.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030307Ab2CQNM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 09:12:57 -0400
Message-ID: <4F648DD3.3000405@shealevy.com>
Date: Sat, 17 Mar 2012 09:12:51 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, matt.fleming@intel.com
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com> <4F5E74A0.60001@zytor.com> <4F5E761B.7010608@shealevy.com> <4F5E775D.7080702@zytor.com>
In-Reply-To: <4F5E775D.7080702@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 6:23 PM, H. Peter Anvin wrote:
> I don't think anyone has implemented an EFI earlyconsole yet

I'm considering taking a shot at this. Do you have any pointers about where to look or how to approach it? Will I have to use UGA/GOP or is there some way to take advantage of the text console after exit_boot_services?

Cheers,
Shea

