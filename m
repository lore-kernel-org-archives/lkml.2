Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab2FSAx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 20:53:28 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60778 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab2FSAx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 20:53:26 -0400
Message-ID: <4FDFCD7F.3070805@gmail.com>
Date: Tue, 19 Jun 2012 08:53:19 +0800
From: "cloudy.linux" <cloudy.linux@gmail.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Simon Baatz <gmbnomis@gmail.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: PROBLEM: New 3.5.0-rcx kernel hang after uncompressing the kernel
 image on Orion ARM machine linkstation pro
References: <4FDF113E.4080505@gmail.com> <20120618183141.GA12544@schnuecks.de>
In-Reply-To: <20120618183141.GA12544@schnuecks.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-6-19 2:31, Simon Baatz wrote:
> On Mon, Jun 18, 2012 at 07:30:06PM +0800, cloudy.linux wrote:
> ...
>> at 3.5-RCx. Both RC2 and RC3 ends the same, the system never boot.
>> The serial console shows that the kernel hangs after "Uncompressing
>> Linux ... done, booting the kernel" message. I tried to enable some
> ...
>
> Did you apply the fix for the printk alignment issue?
>
> https://lkml.org/lkml/2012/6/17/52
>
> - Simon
>

Thank you so much for the light. I'll try it later today.
