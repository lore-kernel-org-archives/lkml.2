Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2HAPPr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 11:15:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6446 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755474Ab2HAPPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 11:15:46 -0400
Message-ID: <50194817.6030805@redhat.com>
Date: Wed, 01 Aug 2012 18:15:35 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: mtosatti@redhat.com, kvm@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: KVM segfaults with 3.5 while installing ubuntu 12.04
References: <5017C8A0.60506@profihost.ag> <5017F19E.4070308@redhat.com> <501817C9.6090405@profihost.ag> <5018EC7D.9090702@redhat.com> <5018F5BB.9070500@profihost.ag> <5018F7E6.4020909@redhat.com> <5018F9F6.70307@profihost.ag> <5018FC9B.8040808@redhat.com> <50191304.6020503@profihost.ag>
In-Reply-To: <50191304.6020503@profihost.ag>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2012 02:29 PM, Stefan Priebe - Profihost AG wrote:

>> Please try qemu-kvm.git master and report.
> 
> Can't get the latest version running. 1st it doesn't know the -id
> parameter. 

I don't know it either, what is it?

> 2nd parameter -vnc
> unix:/var/run/qemu-server/103.vnc,x509,password does not work too => No
> certificate path provided

@item x509-dir=<dir>
Set the x509 file directory. Expects same filenames as -vnc
$display,x509=$dir

@item x509-key-file=<file>
@item x509-key-password=<file>
@item x509-cert-file=<file>
@item x509-cacert-file=<file>
@item x509-dh-key-file=<file>
The x509 file names can also be configured individually.

These also exist in 1.1.  I wonder how it worked without the certificates.

-- 
error compiling committee.c: too many arguments to function
