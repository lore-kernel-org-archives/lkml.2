Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1IPSDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:03:30 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43400 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753089Ab1IPSD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:03:29 -0400
Date: Fri, 16 Sep 2011 20:03:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "'Chaoming_Li'" <chaoming_li@realsil.com.cn>
Subject: Re: 3.1-rc6+ rtl8192se issue
Message-ID: <20110916180323.GA1988@gere.osrc.amd.com>
References: <20110915124406.GA14374@gere.osrc.amd.com>
 <4E721871.7040901@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E721871.7040901@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 10:23:29AM -0500, Larry Finger wrote:
> Would you also try loading rtl8192se with the "ips=0" option? As power
> save is implicated in your traceback, that may help. I will be trying
> "swlps=0 ips=0".

Ok, "ips=0" seems to fix the issue ... almost. I say, almost because I
had only one hang so far for running the box for a day today. Will try
together with "swlps=0" next week.

Thanks.

-- 
Regards/Gruss,
Boris.
