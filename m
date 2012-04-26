Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757610Ab2DZPXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 11:23:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52455 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab2DZPXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 11:23:12 -0400
Date: Thu, 26 Apr 2012 16:23:10 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: George Nychis <gnychis@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: what determines how firmware is loaded? (Q. on
 request_firmware details)
Message-ID: <20120426152310.GB26692@sirena.org.uk>
References: <CA+7oygfcQbOFdCFibTW0pqYQpcLwrqCM_jvKpr=GYFBMn9t3GQ@mail.gmail.com>
 <20120423212144.GA3378@kroah.com>
 <CA+7oygc839sn-s3hHo0XBA_BJop86hZB1h987af1caJ6pAOwyw@mail.gmail.com>
 <20120423225603.GA23276@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423225603.GA23276@kroah.com>
X-Cookie: TAILFINS!! ... click ...
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 03:56:03PM -0700, Greg KH wrote:

> You do realize just how old and obsolete your 3.0.8 kernel is, right?  I
> suggest you update to the latest version, or, if you are stuck with this
> kernel, go ask the vendor who provided it to you for support, as they
> are the best ones to help you out.

Unfortunately 3.0 is what ICS is based off so the overwhelming majority
of vendor code is going to be based on it until the next Android
release.  With my vendor hat on I have to say that we find our upstream
first policy extremely effective so we shouldn't be part of the issue.
