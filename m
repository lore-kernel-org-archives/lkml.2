Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756506Ab0GaUHO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jul 2010 16:07:14 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39367 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533Ab0GaUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jul 2010 16:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=eZ56d2yHUd6OQ5RDLvwT47PsB8wzbbZ03M8tRgzwsEHW9GP30Z5K5Hxj+VD7Tbng5B
         IgRafdUorn6Z3y1UD9HQ8rlYWZ+vhzATyOIiI3qY/4N64mHF5l+fzhJvvIadXaHjf4Sr
         cWYVBkUk3zv9bpEcxp+SqnGoT6n2mXxGD+q3Y=
MIME-Version: 1.0
In-Reply-To: <1280282802-10618-2-git-send-email-johnstul@us.ibm.com>
References: <1280282802-10618-1-git-send-email-johnstul@us.ibm.com>
	<1280282802-10618-2-git-send-email-johnstul@us.ibm.com>
Date: Sun, 1 Aug 2010 05:07:10 +0900
Message-ID: <AANLkTimBkKHQ2ti0K+Lpi+2XctH+V=5n9Y155GwetR0a@mail.gmail.com>
Subject: Re: [RFC][PATCH 2/2] Greatly improve TSC calibration using a timer
From: "Kuwahara,T." <6vvetjsrt26xsrzlh1z0zn4d2grdah@gmail.com>
To: John Stultz <johnstul@us.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Clark Williams <williams@redhat.com>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

How about using the O'Rourke's algorithm?
It's much faster and accurate even if an SMI disturbance occurred
during the calibration process.

Reference
O'Rourke, J. (1981). An on-line algorithm for fitting straight lines
between data ranges.
Communications of the ACM, 24, 574-578. doi:10.1145/358746.358758
