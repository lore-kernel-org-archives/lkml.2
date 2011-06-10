Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab1FJRn2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 13:43:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34088 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753849Ab1FJRn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 13:43:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=qyyGkYEYlg3aPNydUzUnNBN3cYkqIwspIpzglbBdWsXBWT6k22HufTB0eT1ftf/uE7
         KHS+S+w5WSukVj6sYX6G7KEndmDQuId73EqplLSsV1FWqX30IOKbQ1SQnxb2oDxdz04a
         vbsRgLFo3WAEJRFddmt2yHoEKmVFCC4tJGHZ0=
MIME-Version: 1.0
In-Reply-To: <1307726331-28618-1-git-send-email-lars@metafoo.de>
References: <1307726331-28618-1-git-send-email-lars@metafoo.de>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 10 Jun 2011 13:43:05 -0400
Message-ID: <BANLkTimLAfEj+tgNMWjTsanccgfEt9UW1g@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH 1/3] ASoC: Add ADAU1701 codec driver
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, uclinux-dist-devel@blackfin.uclinux.org,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        device-drivers-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 13:18, Lars-Peter Clausen wrote:
> +MODULE_AUTHOR("Lars-Peter Clausen <lars@metafoo.de>");

did you actually rewrite this thing from scratch ?  seems like you
should keep Cliff as the author in git/MODULE_AUTHOR, and then add
your name to the s-o-b list and this macro.

friendly git commits can easily be cherry picked from my tree for asoc stuff:
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=summary
(see the "trunk" branch)
-mike
