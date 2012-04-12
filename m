Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756394Ab2DLVC4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 17:02:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1651 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753446Ab2DLVCy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 17:02:54 -0400
Message-ID: <4F8742E5.40705@redhat.com>
Date: Thu, 12 Apr 2012 14:02:29 -0700
From: Andy Grover <agrover@redhat.com>
Organization: Red Hat
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.3) Gecko/20120307 Thunderbird/10.0.3
MIME-Version: 1.0
To: Chris Boot <bootc@bootc.net>
CC: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, clemens@ladisch.de, nab@linux-iscsi.org,
        stefanr@s5r6.in-berlin.de
Subject: Re: [PATCH v3 00/11] firewire-sbp-target: FireWire SBP-2 SCSI target
References: <1329317248-94128-1-git-send-email-bootc@bootc.net> <1334154043-69076-1-git-send-email-bootc@bootc.net>
In-Reply-To: <1334154043-69076-1-git-send-email-bootc@bootc.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2012 07:20 AM, Chris Boot wrote:
> The FireWire SBP-2 Target is a driver for using an IEEE-1394 connection
> as a SCSI transport. This module uses the SCSI Target framework to
> expose LUNs to other machines attached to a FireWire bus, in effect
> acting as a FireWire hard disk similar to FireWire Target Disk mode on
> many Apple computers.
> 
> Sorry this latest revision has been a long time coming. I was trying to
> chase down a crashing bug (but haven't been able to replicate it), changed
> my mind about a large portion of the code twice, and life got in the way as
> well!

I just want to say this is awesome and I can't wait to try it!

-- Andy
