Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab0IFQQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 12:16:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:65437 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754677Ab0IFQQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 12:16:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DpYf3ABRjniyWYpNb3J252t/jYSR2Gh4iegJFq/QCMeYF1A0VO2cQJTsdoCKW2KhDy
         7o6lAHZ9QccYR3jfhSd8dgshWR1QAwWxudmtebSDvI7VSrzEyZito0eTUFOETOklsPgj
         w693MMJ2yzRdKXVGeOv9MeeN1KAOTVDYdCI9g=
Date: Mon, 6 Sep 2010 20:16:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        vamos-dev@i4.informatik.uni-erlangen.de
Subject: Re: [PATCH 12/14] include/linux: Removing undead ifdef __KERNEL__
Message-ID: <20100906161615.GB6431@lenovo>
References: <cover.1283782698.git.qy03fugy@stud.informatik.uni-erlangen.de> <982ff35c4e79349b4bc4a224a6134e1c5ec38431.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <982ff35c4e79349b4bc4a224a6134e1c5ec38431.1283782701.git.qy03fugy@stud.informatik.uni-erlangen.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 04:36:59PM +0200, Christian Dietrich wrote:
> The __KERNEL__ ifdef isn't necessary at this point, because it is
> checked in an outer ifdef level already and has no effect here.
> 
> Signed-off-by: Christian Dietrich <qy03fugy@stud.informatik.uni-erlangen.de>
> ---

The origin looks weird indeed. So I presume it's here for historical reasons.
Well, from git log it shows a lot of glibc tricks were here. And the former
top __KERNEL__ is by commit 9c501935a3cdcf6b1d35aaee3aa11c7a7051a305 so

Reviewed-by: Cyrill Gorcunov <gorcunov@gmail.com>

Thanks Christian

	-- Cyrill
