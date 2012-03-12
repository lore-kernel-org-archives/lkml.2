Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838Ab2CLW2I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:28:08 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:49603 "EHLO
	homiemail-a41.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757548Ab2CLW2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:28:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=i1rDmw1HGfmCniE9ev18cPQtbWzKL/Zauxi5c+gNKFgNKIu4TC5gjpWtsaQA5
	1SVZ56FdCRpQmAYuLb4uVcSO6+B8hyeoLwR9vsLnNIuPLtgGh0v1zJpMH8G5UIUG
	IibgpLtCy6uV3DzsCHk5Qu9q9O54bcOYxRZ/JT4mgHEmV4=
Message-ID: <4F5E7873.8070500@shealevy.com>
Date: Mon, 12 Mar 2012 18:28:03 -0400
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
> I don't think anyone has implemented an EFI earlyconsole yet, and you
> can't rely on EFI handing over the screen in a mode the kernel can
> handle with earlyconsole=vga, so there aren't really any other alternatives.

Ah, ok, so what I'm looking for doesn't exist (yet?). Thanks.

~Shea
