Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab2DBUx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:53:28 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59703 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2DBUx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:53:26 -0400
Date: Mon, 2 Apr 2012 22:53:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
Message-ID: <20120402205322.GA31126@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
	Joe Perches <joe@perches.com>
References: <20120402164920.GA13264@x1.osrc.amd.com>
 <1333385618.15422.17.camel@joe2Laptop>
 <20120402171733.GB13264@x1.osrc.amd.com>
 <4F79E5A5.9000004@lwfinger.net>
 <20120402203211.GA27889@liondog.tnic>
 <4F7A103E.90007@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F7A103E.90007@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 03:46:54PM -0500, Larry Finger wrote:
> Users will see nothing more than before!
> 
> Before CONFIG_RTLWIFI_DEBUG was allowed to be set, the driver always
> compiled in the debug code, but only those messages with the
> DBG_EMERG code were actually output. With the parameter set to Y,
> nothing changed. If the module is loaded with the "debug=X" option,
> where X is greater than 0, then other messages will be seen. That
> dynamic setting of the level is enough.
> 
> The only change when the configuration parameter is set to N is that
> the entire debug setup compiles away. The driver is a lot smaller,
> but there is no debugging.

Yes, yes, I knew there should be some sane default there,
rtlpriv->dbg.global_debuglevel remains 0 which is DBG_EMERG. I stand
corrected, thanks.

-- 
Regards/Gruss,
    Boris.
