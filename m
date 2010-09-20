Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126Ab0ITJZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 05:25:35 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34435 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480Ab0ITJZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 05:25:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=m4pFSPFvW2Q34oEj/Yh5AvODYTuup3U95sieDGWRrHJlR9eL7Xw3zbE78Sf/dikjlJ
         UG1jANfPMagCtV5CzzLRWU23IWEejCpjN++D5UOEkN8Gfu/KFZW7HuWJtEpDWUAAAX0n
         Mu33abTTptWRoCFdb1vxfQHW5QQZ7wKDTRdtk=
Subject: Re: ahci rmmodable and shouldn't
From: Pedro Francisco <pedrogfrancisco@gmail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
In-Reply-To: <4C9602E4.4090007@gmail.com>
References: <201009162256.04765.pedrogfrancisco@gmail.com>
	 <47010.148.87.67.141.1284674336.squirrel@www.xenotime.net>
	 <4C933A8F.2080305@gmail.com> <1284892106.2650.4.camel@sundae-v2>
	 <4C9602E4.4090007@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Sep 2010 10:25:26 +0100
Message-ID: <1284974726.11757.9.camel@sundae-v2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dom, 2010-09-19 at 14:32 +0200, Tejun Heo wrote: 
> I think it works the same way for any other SCSI driver and it's
> pretty convenient during development.  You can unload any network
> driver module while the network is still up too.  Module reference
> count doesn't have any specific meaning of 'use' preassigned other
> than it's there to prevent unloading module while the code and data
> are being actively used by the processor.  It's unfortunate that the
> way module reference count is used for libata is causing discomfort to
> you but I need much better reason to change it.

Discomfort? Not really, sorry if my stubbornness felt like it. No, I'm
fine with it.

I just thought it was weird the change of behaviour from 2.6.32, plus
felt that the "Used by" field by lsmod was incorrectly set at 0 since
the module is, in fact, being used (e)

If you say both behaviours are expected and preferred, besides being
consistent with other modules (something I didn't know), I really can't
argue any more.

Thanks for the explanation and sorry for the noise :)

-- 
Pedro

