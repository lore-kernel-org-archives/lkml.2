Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab1EZGI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 02:08:56 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:33040 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756995Ab1EZGIz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 02:08:55 -0400
Date: Thu, 26 May 2011 06:08:43 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, James Morris <jmorris@namei.org>,
        David Safford <safford@watson.ibm.com>, Greg KH <greg@kroah.com>,
        Dmitry Kasatkin <dmitry.kasatkin@nokia.com>
Subject: Re: [PATCH v5 00/21] EVM
Message-ID: <20110526060842.GA13933@localhost.ucw.cz>
References: <1305557115-15652-1-git-send-email-zohar@linux.vnet.ibm.com> <20110518172552.6d482c7a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518172552.6d482c7a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xcOn Wed 2011-05-18 17:25:52, Andrew Morton wrote:
> On Mon, 16 May 2011 10:44:54 -0400
> Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> 
> > Extended Verification Module(EVM) detects offline tampering of the security
> > extended attributes (e.g. security.selinux, security.SMACK64, security.ima),
> > which is the basis for LSM permission decisions and, with the IMA-appraisal
...
> Thirdly, I'm not seeing a description of the user interface anywhere. 
> Please fully describe it in a manner which can be efficiently reviewed.
> For example, if there are any user-provided inputs, describe them.  If

Fourthly, is it likely to find its way to the next cellphone I buy,
and will it prevent me from rooting it?
								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
