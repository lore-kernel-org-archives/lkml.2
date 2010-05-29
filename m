Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0E2JHI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 05:07:08 -0400
Received: from mail-ew0-f216.google.com ([209.85.219.216]:52424 "EHLO
	mail-ew0-f216.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0E2JHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 05:07:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=aT235Hf7YT3Wzz/bTx/i3cKqyFg5Z6nvWfI61mzXxLkOl8Lq8r+VCJ264KWx2xKYd8
         TdIaGI1iV+ngsYGa+OrQ4kz+XQETg4cTrf9oMD1rU6z/lHmjI65kuyk2WO1g/IpRZjBC
         ePwYdEDgTLmVCCQEHMSuGnfHTUe7BJiQTh3wQ=
MIME-Version: 1.0
In-Reply-To: <20100529021624.GA2538@brick.ozlabs.ibm.com>
References: <2d460de71003260850x7f90d04cy79ac853464108182@mail.gmail.com>
	<20100326160226.0159ac3b@lxorguk.ukuu.org.uk>
	<4BACE827.4070006@gmail.com>
	<20100326170428.6c1ad66c@lxorguk.ukuu.org.uk>
	<4BB31E00.8060204@netservers.co.uk>
	<20100529021624.GA2538@brick.ozlabs.ibm.com>
Date: Sat, 29 May 2010 11:06:59 +0200
Message-ID: <AANLkTimOxMHpysLR6fQn0fhLkvMZbEd0gcIwQlINq49J@mail.gmail.com>
Subject: Re: [Patch] fix packet loss and massive ping spikes with PPP 
	multi-link
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ben McKeegan <ben@netservers.co.uk>, netdev@vger.kernel.org,
       linux-ppp@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Alexander E. Patrakov" <patrakov@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 04:16, Paul Mackerras <paulus@samba.org> wrote:

> I like this a lot better than the other proposed patch.

Not that it really matters, but we would be happy with either patch
as long as we can stop patching mainline :)


Richard
