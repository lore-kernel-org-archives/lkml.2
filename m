Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932283Ab2HHG2I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 02:28:08 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:33580 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757822Ab2HHG2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 02:28:03 -0400
Message-ID: <50220779.9000206@metafoo.de>
Date: Wed, 08 Aug 2012 08:30:17 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120613 Icedove/3.0.11
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: question on devm_kfree
References: <5021FF92.8030904@nvidia.com>
In-Reply-To: <5021FF92.8030904@nvidia.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 07:56 AM, Venu Byravarasu wrote:
> As per comments related to devm_kzalloc, memory allocated using it is
> freed automatically.
> However there is a function called devm_kfree, comment section of which
> says that it is used to free memory allocated using devm_kzalloc().
> If memory allocated by devm_kzalloc is freed automatically, what's the
> need & significance of devm_kfree?
> 
> Thanks,
> Venu
>

Hi,

Memory allocated with devm_kzalloc is freed at the end of the lifetime of the
device it is attached to. If you for some reason want to free allocated with
memory devm_kzalloc before that of the lifetime of the device can use devm_kfree.


- Lars
