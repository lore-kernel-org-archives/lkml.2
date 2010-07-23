Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0GWSrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:47:17 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57660 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab0GWSrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:47:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xqBUhqX8Z8TmDAfDF1jV0ONv7IOHow9OH2jY1DvI8yybJwHYi8rrAZioVfJ1hrLiVs
         Bgh1vUBhAKI3uJo84zUIcIeSKnkK2/tjTjPQpge8L3GzCcIt2ruJafWDMymaV39SCsOd
         gMypHQp9QMdxOk5W0w/oEAJVU9adqnSO4UdOc=
Subject: Re: [RFC] [PATCH procfs] Add process age
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave.bueso@gmail.com
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
In-Reply-To: <20100723183549.GA10518@x200>
References: <1279907271.4335.3.camel@cowboy>  <20100723183549.GA10518@x200>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Jul 2010 14:47:10 -0400
Message-ID: <1279910830.1851.5.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-23 at 21:35 +0300, Alexey Dobriyan wrote:
> On Fri, Jul 23, 2010 at 01:47:51PM -0400, Davidlohr Bueso wrote:
> > This patch exports a process's age, in seconds, adding a /proc/#/age file.
> 
> What for?

I have not found any straight way to get the run time of a processes,
without having to interpret the start_time entry in /proc/#/stat and
manually subtract the uptime from it.

This small file simply aids the users to obtain the information easier
and quicker. Another alternative would be to add an entry
in /proc/#/status.

Davidlohr

