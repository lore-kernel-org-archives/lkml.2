Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045Ab0KYJ5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 04:57:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41141 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751681Ab0KYJ5s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 04:57:48 -0500
Message-ID: <4CEE32F0.4030302@redhat.com>
Date: Thu, 25 Nov 2010 10:57:04 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101110 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ed Lin - PTU <ed.lin@promise.com>
CC: Dan Carpenter <error27@gmail.com>, Markus Schulz <msc@antzsystem.de>,
        linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: data corruption with stex (Promise HW-Raid) driver and device-mapper
References: <85ABFDC4641C4847BA6088F2982EFD8F049D4273@nonamew.ptu.promise.com>
In-Reply-To: <85ABFDC4641C4847BA6088F2982EFD8F049D4273@nonamew.ptu.promise.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/16/2010 02:35 AM, Ed Lin - PTU wrote:
> The stex driver sets sg_tablesize as 32 (for st_yel it's 38) in the probe
> entry. It seems that this value was overridden by the system if using
> dm/lvm, for unknown reason. The driver received requests with more
> sg items than registered. Sg item number could be as high as 64. This
> is completely unexpected. The firmware could not handle such
> requests, and error occurred.

Device-mapper respects hw restrictions, so it must be bug somewhere.

Please cc dm-devel if you think that problem is there.

Milan
