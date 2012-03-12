Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2CLS53 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 14:57:29 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:60637 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891Ab2CLS51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 14:57:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:content-type:
	content-transfer-encoding; q=dns; s=shealevy.com; b=kr7DcgnhJeJp
	Vdg/ZyMOTbh9axkeF2/WpspvdQ21gl7+JzDIspAeTSvLX6YPe/l8ZhwTIsyWjQzo
	FaDCgi70S6GzhcXXQOeWUmIYdBztbvKg+yvIrt/9xZx1EQiD4cHen/B89V4wJKyV
	Z9EUXHorpYmxQijZYWCGG2ARBwSeIyU=
Message-ID: <4F5E46EA.7020602@shealevy.com>
Date: Mon, 12 Mar 2012 14:56:42 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: matt.fleming@intel.com
Subject: EFI Boot Stub Early Console
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

How do I get the early boot console to show up on my screen when booting 
with the EFI boot stub? I can see it through the serial port if I set 
console=tty0, and I see the second half of the boot sequence after my 
initrd loads fbcon, but the screen remains unchanging until then. I'm 
using 3.3-rc7 on Virtualbox's EFI implementation.

Thanks,
Shea
