Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756317Ab0FCTuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 15:50:40 -0400
Received: from mail-pz0-f185.google.com ([209.85.222.185]:50675 "EHLO
	mail-pz0-f185.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0FCTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 15:50:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=m8aLWLd9SaNJSseWUTq7SuvdGVT/I0rMSzqp7fxBXADH0thPWVUzi7hoSdzYJB9kKW
         i81nrUkKRpbLO03KSqf1yBvmGjiWXdwEfz3mjGFeYbwrenkEN/+vZwtEGU2LQC8v66aE
         1T2RAMX8yiqNq+EcxnE3aykV9UUNeDL45eFKc=
MIME-Version: 1.0
In-Reply-To: <20100603193527.GK28492@bombadil.infradead.org>
References: <AANLkTilhvjn1ypRoKs2CxJdA1zDkaT5i64vh0ZtfjwMk@mail.gmail.com>
	<20100603193527.GK28492@bombadil.infradead.org>
Date: Fri, 4 Jun 2010 03:50:36 +0800
Message-ID: <AANLkTikqNZB9sicxfCfYY7Koxj2CUPpESxYe5ikPYiMd@mail.gmail.com>
Subject: Re: How do I ignore the changes made by CVS keyword substitution 
	efficiently?
From: Lin Mac <mkl0301@gmail.com>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Git Mailing List <git@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/6/4 Kyle McMartin <kyle@mcmartin.ca>:
> You want the -ko option to cvs checkout/update which will use the
> original keywords from the import.
Yes, that could be done. But usually it would be faster if I could
solve it myself than asking them to release again.

Best Regards,
Mac Lin.
