Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab2DCSRD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 14:17:03 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:2001 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2DCSRA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 14:17:00 -0400
X-Server-Uuid: B730DE51-FC43-4C83-941F-F1F78A914BDD
Message-ID: <4F7B3E51.5020403@broadcom.com>
Date: Tue, 3 Apr 2012 20:15:45 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-Version: 1.0
To: Chester <somethingsome2000@gmail.com>
cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: brcmsmac driver is ghost in 3.3
References: <CAAE6i0hHT7A+x7Q9zct0oxQv44Y8WchiKdeRbNrzRRp+fJNGuQ@mail.gmail.com>
 <CAAE6i0gVsYnpa82FrKCNV5sszr38But4Og6D20cv4r8BF3Tv=Q@mail.gmail.com>
In-Reply-To: <CAAE6i0gVsYnpa82FrKCNV5sszr38But4Og6D20cv4r8BF3Tv=Q@mail.gmail.com>
X-WSS-ID: 63659F473E013497906-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2012 07:05 AM, Chester wrote:
> And this is when I curse at all the google results that say "blacklist
> bcma" ... brcmsmac DEPENDS on bcma /facepalms and goes to sleep..

brcmsmac changed basically from a pci device driver to a bcma device 
driver. So before 3.3 it was good to blacklist bcma to avoid it from 
claiming the device away from brcmsmac.

For 3.3, brcmsmac relies on bcma indeed.

Gr. AvS

