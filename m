Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1DSL3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 07:29:53 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:55584 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975Ab1DSL3w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 07:29:52 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DAD72A7.90904@cam.ac.uk>
Date: Tue, 19 Apr 2011 12:31:51 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20110122 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org, greg@kroah.com, adobriyan@gmail.com
Subject: Re: [PATCH 1/3] Add a usr_strtobool function matching semantics of
 existing in kernel equivalents
References: <1300973025-32497-1-git-send-email-jic23@cam.ac.uk> <1300973025-32497-2-git-send-email-jic23@cam.ac.uk> <87oc433tuw.fsf@rustcorp.com.au>
In-Reply-To: <87oc433tuw.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/11 02:36, Rusty Russell wrote:
> On Thu, 24 Mar 2011 13:23:43 +0000, Jonathan Cameron <jic23@cam.ac.uk> wrote:
>> This is a renamed and relocated fixed version of previous kstrtobool RFC
> 
> Please just call it strtobool, usr_ implies it's a user pointer.
Will do. I guess that is still distinct enough from kstrto* to avoid
anyone expecting the semantics from this one.
> 
> And there's no need to introduce a new var in debugfs, just do:
> 
> 	if (strtobool(buf, &bv) == 0)
> 		*val = bv;
Excellent point.
> 
> And yes, I'll take it for the param stuff.
Thanks. New version coming shortly.
> 
> Thanks,
> Rusty.

