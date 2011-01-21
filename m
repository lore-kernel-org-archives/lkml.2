Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab1AUGVv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 01:21:51 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56295 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1AUGVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 01:21:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=J3/bHSocUoFFjIpv4tNjqMR8sq3zE6C9fTqCEUmUGFLV1L4bR1LsYlcsPfLx4Zkpjp
         HLvN+Ti2cmKopKM5MlA5h56i7AgegN5qAGtz5KreFWE5uYyov0vz8aO9lIJcc1JREwRe
         Y4gWEFQDFZ24AbJOpJqKHvT4CGE68m+SwQVV4=
Date: Fri, 21 Jan 2011 09:21:36 +0300
From: Dan Carpenter <error27@gmail.com>
To: ahern.michael.t@gmail.com
Cc: gregkh@suse.de, u.kleine-koenig@pengutronix.de, julia@diku.dk,
        nikai@nikai.net, morgan.gatti@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Coding style in serial2002
Message-ID: <20110121062136.GR2721@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	ahern.michael.t@gmail.com, gregkh@suse.de,
	u.kleine-koenig@pengutronix.de, julia@diku.dk, nikai@nikai.net,
	morgan.gatti@gmail.com, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1295573538-18973-1-git-send-email-ahern.michael.t@gmail.com>
 <1295573538-18973-2-git-send-email-ahern.michael.t@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295573538-18973-2-git-send-email-ahern.michael.t@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 21, 2011 at 12:32:18PM +1100, ahern.michael.t@gmail.com wrote:
> From: Michael Ahern <ahern.michael.t@gmail.com>
> 
> This patch removes incorrect mutli-line comment
> 

This should have just been combined with the first patch.

Also the subject should be:

[PATCH] Staging: comedi: Coding style in serial2002

regards,
dan carpenter
