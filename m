Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757435Ab2CLWSI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 18:18:08 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:39069 "EHLO
	homiemail-a45.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753780Ab2CLWSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 18:18:07 -0400
X-Greylist: delayed 12081 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Mar 2012 18:18:07 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=ERkbkIlTFleSTY5bbZqLQM/O4dqRXJfPAqhhtQaRB4UzrDup/T0JePvDSGhHL
	ViKeQOaFQViCF9JVuPYTkY8PR1FQv82fCahL7FWDY3DhMOdAAL1+Xlo5Fh0MJZQv
	is5QNZw1zJNN2d7ZN5Z1XuCU1IMndP1k9pGgk5t4K1MEc4=
Message-ID: <4F5E761B.7010608@shealevy.com>
Date: Mon, 12 Mar 2012 18:18:03 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, matt.fleming@intel.com
Subject: Re: EFI Boot Stub Early Console
References: <4F5E46EA.7020602@shealevy.com> <4F5E47E4.2070303@shealevy.com> <4F5E74A0.60001@zytor.com>
In-Reply-To: <4F5E74A0.60001@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/12 6:11 PM, H. Peter Anvin wrote:
> On 03/12/2012 12:00 PM, Shea Levy wrote:
>> On 3/12/12 2:56 PM, Shea Levy wrote:
>>> console=tty0
>> Sorry, that should have been console=ttyS0
> Have you tried earlyprintk=serial,ttyS0?
>
> 	-hpa
>

Just tried. Still nothing in the VirtualBox window, serial port showed 
boot output up until "[    0.000000] console [tty0] enabled, bootconsole 
disabled", when the rest of the boot process happened in VirtualBox.

~Shea
