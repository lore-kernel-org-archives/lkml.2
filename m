Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932415Ab2BATuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 14:50:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15498 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756814Ab2BATuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 14:50:51 -0500
Message-ID: <4F29978A.3010707@redhat.com>
Date: Wed, 01 Feb 2012 11:50:34 -0800
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.24) Gecko/20111104 Red Hat/3.1.16-2.el6_1 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Clemens Ladisch <clemens@ladisch.de>
CC: Chris Boot <bootc@bootc.net>, target-devel@vger.kernel.org,
        linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: FireWire/SBP2 Target mode
References: <4E4BD560.4010806@bootc.net> <4E4D3B88.30003@ladisch.de>
In-Reply-To: <4E4D3B88.30003@ladisch.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry to raise this thread from the dead.

Chris Boot wrote Aug 2011-ish:
> I would very much like to see something like this added to the
> kernel, and would very much like to contribute to writing this
> feature. However my kernel development knowledge is very limited
> indeed so this would require a lot hand-holding and mentoring.

If you're still interested, I'd definitely encourage you to work on this
project. Me and others on target-devel would be happy to help with any
target-related advice.

On 08/18/2011 09:19 AM, Clemens Ladisch wrote:
> Chris Boot wrote:
>> Now that we have a nice SCSI target framework in the kernel, and drivers
>> either in-tree or being worked on for iSCSI, FC, FCoE, SAS and iSER, I
>> was wondering about the possibility of adding FireWire to that list.
> 
> As far as I can tell from briefly looking at the framework, this would
> require both a fabric module (which is nicely abstracted) and a new
> protocol (which doesn't seem to be).
> 
> Is there any documentation of how to add a new LIO protocol?
> 
> And what is the difference between a protocol and a fabric?

Right now the documentation is the other fabric modules, alas.

You're saying the sbp2 protocol can theoretically be used other places
besides firewire? I'd say put it all in the fabric module for now.

You can also join irc.oftc.net #storage and ask more questions there.

Regards -- Andy
