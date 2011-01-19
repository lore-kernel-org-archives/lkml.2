Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1ASFXe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 00:23:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33076 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750751Ab1ASFXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 00:23:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bUQMKQJB4cEkyG/0RbYfyMmSCiCPAZaqotvtassiSCoOT8EPCEL81tm42KttNpk9tG
         KJ99eZrHYAem8OkBJkp9D1ZNEo4LHrLwbnWpLODmS4/zxLtrmTzlq9Gql0g1YErzDMJi
         2wZc/jUhDth9Wi2cVKlYozgaSfAK4FCTJblEc=
Date: Tue, 18 Jan 2011 21:23:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rakesh Iyer <riyer@nvidia.com>
Cc: "tsoni@codeaurora.org" <tsoni@codeaurora.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "shubhrajyoti@ti.com" <shubhrajyoti@ti.com>,
        "ccross@android.com" <ccross@android.com>,
        "konkers@android.com" <konkers@android.com>,
        "olof@lixom.net" <olof@lixom.net>, Andrew Chew <AChew@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH v5] input: tegra-kbc - Add tegra keyboard driver
Message-ID: <20110119052324.GA27751@core.coreip.homeip.net>
References: <1294943248-18631-1-git-send-email-riyer@nvidia.com>
 <20110118051216.GD23851@core.coreip.homeip.net>
 <1FC56210173BB445BD77F608D6FB8D03165A00807E@HQMAIL03.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FC56210173BB445BD77F608D6FB8D03165A00807E@HQMAIL03.nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 07:28:29PM -0800, Rakesh Iyer wrote:
> Sorry for the late response as I was not working on it on Monday.
> 
> The patch as is did not work. I am debugging this currently.

Sorry about that. If you describe the effects you are seeing I might try
to think where I messed up.

> 
> Once I find a fix, can I resend all the driver code as one patch file?
> I will include your 2nd patch in it as well.

Sure.

> 
> Secondly, the driver is a platform driver for Tegra platforms. The
> platform code needs some of the #defines to be present in kbc.h, so
> you will see some of the defines moved back to kbc.h from tegra-kbc.c
> 

I only moved KBC_MAX_COL, KBC_MAX_ROW and KBC_MAX_KEY since they are
not needed in keymaps expressed via struct matrix_keypad_data. But if
they are needed for something else that's fine.

-- 
Dmitry
