Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754219Ab1AJTb0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:31:26 -0500
Received: from webmail10.mail.sp.isp-net.nl ([217.149.192.62]:45704 "EHLO
	webmail10.mail.sp.isp-net.nl" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753856Ab1AJTbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:31:21 -0500
X-Greylist: delayed 675 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jan 2011 14:31:21 EST
Message-ID: <4D2B5C08.4010109@xmsnet.nl>
Date: Mon, 10 Jan 2011 20:20:40 +0100
From: Hans de Bruin <jmdebruin@xmsnet.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.16) Gecko/20101125 Thunderbird/3.0.11
MIME-Version: 1.0
To: Siddu <siddu.sjce@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Bug in linux-2.6.37-rc8+: Weird X display upon hibernating
References: <AANLkTinCSu68cC_jzO8MZs4Q=u+EABiZxkRv3gbyfqMk@mail.gmail.com> <AANLkTin4yh3mQ7pbGPvYFNgNnRDVrmJUD4yUJT1tusC7@mail.gmail.com>
In-Reply-To: <AANLkTin4yh3mQ7pbGPvYFNgNnRDVrmJUD4yUJT1tusC7@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Language-Detected: en
X-Spam-Scanned: InterNLnet Mail Scan System V2.03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2011 06:07 PM, Siddu wrote:
> seems like its not getting much attention here .... atleast can anyone
> tell me which is the right place to be brought into notice ?

If you want to avoid the lkml you might want to look at buzilla. Rafael 
Wysocki has a list of bugs/regressions for each kernel release. The list 
for 2.6.37 is at:

https://bugzilla.kernel.org/show_bug.cgi?id=21782

If your problem is not there yet, you can add an entry.

-- 
Hans






