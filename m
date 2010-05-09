Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab0EIWKx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 18:10:53 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:39846 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab0EIWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 18:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=uHMLWk4b/zyC/m1F0k90YK/V2DPy4jQBlYUb+fp/S8mvdP0wZ5SyCZhaoGhlOXLJvu
         SW9GMkUx1Vv7VLfbNx76Hm8NCFfK3kkmixHcQx8PW3TkYXLlkpSWP353efnBo75MANbB
         gRHo8zNAJtlZss0ilvk6kD6UOeK63Hyal7zdk=
Date: Mon, 10 May 2010 00:10:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [Bug #15805] reiserfs locking
Message-ID: <20100509221043.GB5817@nowhere>
References: <10aqDnTJcLO.A.mLE.48y5LB@chimera> <HqroMXsT-CJ.A.9DF.s9y5LB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <HqroMXsT-CJ.A.9DF.s9y5LB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 11:17:36PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.33.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15805
> Subject		: reiserfs locking
> Submitter	: Alexander Beregalov <a.beregalov@gmail.com>
> Date		: 2010-04-15 21:02 (25 days old)
> Message-ID	: <t2ka4423d671004151402n7b2dc425mdc9c6bb9640d63fb@mail.gmail.com>
> References	: http://marc.info/?l=linux-kernel&m=127136535323933&w=2



I'll do some tests and see if something caused this recently.

