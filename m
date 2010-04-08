Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab0DHHjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:39:22 -0400
Received: from mail-bw0-f217.google.com ([209.85.218.217]:40911 "EHLO
	mail-bw0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0DHHjT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:39:19 -0400
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Apr 2010 03:39:18 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=geON2sXX9u4reh3gIIrTxtk2ORc3BFbgz32QIhx3ryEYCTJ+5G/BDe0V6JPqZqXTJv
         buFR1kNHAdVdLDCfeN9jenRpAuxqGtxHWc72oqKpMSpcnxRN2HzZZuxfcr8U9vIYbG4X
         emSnV6XqPZwjwcvijUbV9i4jUtVI1aCgWShUc=
MIME-Version: 1.0
In-Reply-To: <JVS2s9dmTsP.A.ttH.0tPvLB@chimera>
References: <6Pphclm24fK.A.lSF.qsPvLB@chimera>
	 <JVS2s9dmTsP.A.ttH.0tPvLB@chimera>
Date: Thu, 8 Apr 2010 09:32:53 +0200
Message-ID: <w2vb637ec0b1004080032m12d2e9b7k5f0f2f4e49b68c7c@mail.gmail.com>
Subject: Re: [Bug #15619] Regression - Linux 2.6.34-rc1 - i915 - Render error 
	detected
From: Fabio Comolli <fabio.comolli@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

disappeared between -rc2 and -rc3

On Wed, Apr 7, 2010 at 11:13 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=15619
> Subject         : Regression - Linux 2.6.34-rc1 - i915 - Render error detected
> Submitter       : Fabio Comolli <fabio.comolli@gmail.com>
> Date            : 2010-03-17 21:58 (22 days old)
> Message-ID      : <b637ec0b1003171458t524d168fiab52ce2b3431e3c9@mail.gmail.com>
> References      : http://marc.info/?l=linux-kernel&m=126886311908558&w=2
>
>
>
