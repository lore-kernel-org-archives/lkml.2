Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932377Ab1EJMlX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 08:41:23 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:60585 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1EJMlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 08:41:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DC9330A.5060106@cam.ac.uk>
Date: Tue, 10 May 2011 13:43:54 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: "K. Y. Srinivasan" <kys@microsoft.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, virtualization@lists.osdl.org,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Abhishek Kane <v-abkane@microsoft.com>
Subject: Re: [PATCH 005/206] Staging: hv: Rename the device type variable
References: <1304978242-22958-1-git-send-email-kys@microsoft.com> <1304978288-22999-1-git-send-email-kys@microsoft.com> <1304978288-22999-5-git-send-email-kys@microsoft.com> <4DC90F37.6010000@cam.ac.uk> <20110510121310.GA27396@suse.de>
In-Reply-To: <20110510121310.GA27396@suse.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/11 13:13, Greg KH wrote:
> On Tue, May 10, 2011 at 11:11:03AM +0100, Jonathan Cameron wrote:
>> On 05/09/11 22:54, K. Y. Srinivasan wrote:
>>> Rename the variable g_blk_device_type.
>> Why?
> 
> Because "g_blk_device_type" is in Hungarian notation, which isn't needed
> in the kernel.
> 
Fair enough, I'd misunderstood what g_blk referred to. Sorry for the noise.
