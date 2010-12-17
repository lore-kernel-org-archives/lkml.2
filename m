Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0LQTec (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 14:34:32 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64766 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754454Ab0LQTe1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 14:34:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=lJFrdMpjth+t53KtZaz93hCTBo2KDIS/iGLcTKfBd2nodmTwW0doVEHGewLUVLcr7G
         DNhvfu7KqDHs+J43waYfgQI1N+iWvS4qoOEq8V0Lv0QIK9Hzlf3F5U6pFkI5/ORYx0YU
         gWXhWhVVH/TRAIGdrHiXqL0ERai2QUqUneLAs=
Date: Fri, 17 Dec 2010 11:34:19 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] input: mt updates for 2.6.38
Message-ID: <20101217193419.GA2576@core.coreip.homeip.net>
References: <4D09F9E2.6060900@euromail.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D09F9E2.6060900@euromail.se>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 12:37:06PM +0100, Henrik Rydberg wrote:
> Dmitry,
> 
> Please pull from
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rydberg/input-mt.git next
> 
> to re-receive input-mt updates for 2.6.38.
> 
> As a one-time measure, the tree has been rewound all the way to 2.6.37-rc1, to
> keep our trees at a common checkpoint. Hereafter, the branch will be kept stable
> and synchronized at a common checkpoint.
> 
> Content-wise, the filename change has been folded into the first commit. The
> finger-count report and the trkid documentation have been folded into the commit
> where they are introduced. Furthermore, MT_TOOL_ENVELOPE has been dropped
> completely, and is going to be replaced by an input device quirk. The overall
> documentation changes have been held back for another respin. Lastly, another
> device patch has been added to hid-egalax.
> 

Pulled, thanks Henrik.

-- 
Dmitry
