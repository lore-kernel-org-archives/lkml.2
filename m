Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab0KUUXd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 15:23:33 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33232 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419Ab0KUUXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 15:23:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=tZs4TbmkxVM6D4gDIF6utIc25x4VlYrNFWVyo5AKFBm2YkBgV10x+FKzyJf8yIwGAB
         Fw03ePjtON7eO0UjBcvGlIo83QQIFIxQ1RFpWr3e9B11+RoFcwhVdCjoxy78CYqlw6nP
         pm7oNKFWFXRRpQBLy5dLYFhNjeQOXeWKqtQ0A=
Date: Sun, 21 Nov 2010 21:22:26 +0100
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #22102] [2.6.36-09452-g2d10d87] BUG: unable to handle
 kernel NULL pointer dereference at (null)
Message-ID: <20101121202226.GA16656@Pilar.aei.mpg.de>
References: <sKkKYVppECN.A.KhC.Phb5MB@chimera>
 <ATV3yiK8i4C.A.HCF.jib5MB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ATV3yiK8i4C.A.HCF.jib5MB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fr 19.Nov'10 at  0:42:44 +0100, Rafael J. Wysocki wrote:
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22102
> Subject		: [2.6.36-09452-g2d10d87] BUG: unable to handle kernel NULL pointer dereference at (null)
> Submitter	: Carlos R. Mafra <crmafra2@gmail.com>
> Date		: 2010-10-30 20:07 (20 days old)
> Message-ID	: <20101030200751.GA2866@Pilar.aei.mpg.de>
> References	: http://marc.info/?l=linux-kernel&m=128846935825136&w=2

2.6.37-rc2 does not have the problem, this can be closed.
