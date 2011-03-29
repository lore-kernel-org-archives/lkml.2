Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1C2Uke (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 16:40:34 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42158 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab1C2Ukc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 16:40:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=xoegenyi9IM6eJUFLAJUJdC8oPOtCb097bX5GUQ2D9MZOd8Jjod8Q0THx54boUKlll
         jksrT8IcAE9ywjYTKmgmAxw6W8lxjcpkOVtUvTGH1/pahBUVL2ZApsVhM2Z1xrML8M7b
         0hZyR8mXVPSXhFR0dRGKCM0Kt51jfb1GwuavE=
Date: Tue, 29 Mar 2011 17:40:25 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Michael Witten <mfwitten@gmail.com>
Cc: Raghavendra D Prabhu <rprabhu@wnohang.net>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Use the environment variable PYTHON if defined
Message-ID: <20110329204024.GA20824@ghostprotocols.net>
References: <20110326224408.GA1336@Xye>
 <20110328144721.GB17872@ghostprotocols.net>
 <e987828e-87ec-4973-95e7-47f10f5d9bab-mfwitten@gmail.com>
 <20110329181524.GA5140@Xye>
 <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=3Wq3Xt-QFR-FLRQ1kBjpWjaBZNFpOiE_T15WH@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Mar 29, 2011 at 02:15:30PM -0500, Michael Witten escreveu:
> On Tue, Mar 29, 2011 at 13:15, Raghavendra D Prabhu <rprabhu@wnohang.net> wrote:
> > the patch submitted by Michael seems to be taking care of far
> > more cases than mine, so that is much better.
> 
> One major issue with my current patch is that I opted to stop the
> build with an error message even when using the default python command
> names; is this undesirable? Is it better to fail silently as before
> (via the somewhat cryptic Python.h message), or is it better to force
> the user to specify that no python support should be built?

I think that the best course of action is to emit a warning and go, i.e.
we don't have to make it harder for people that don't want $FOO support
to make that clear.

Just not having python-dev{el} installed should be enough to disable the
feature. For people that want the feature the warning is enough to tell
them to install the missing package.

- Arnaldo
