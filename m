Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab2LGTVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:21:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:45316 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448Ab2LGTVr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:21:47 -0500
Date: Fri, 7 Dec 2012 13:21:38 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: James Morris <james.l.morris@oracle.com>,
        linux-security-module@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>, linux-kernel@vger.kernel.org,
        Eric Paris <eparis@redhat.com>, "Andrew G. Morgan" <morgan@kernel.org>,
        mtk.manpages@gmail.com
Subject: Re: [PATCH] Document how capability bits work
Message-ID: <20121207192138.GA22308@sergelap>
References: <3c3146b8bea5d8590ebc40ca1d22a562a5172873.1354904275.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c3146b8bea5d8590ebc40ca1d22a562a5172873.1354904275.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andy Lutomirski (luto@amacapital.net):
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
> ---
>  Documentation/security/capabilities.txt | 161 ++++++++++++++++++++++++++++++++
>  1 file changed, 161 insertions(+)
>  create mode 100644 Documentation/security/capabilities.txt

TBH, I think a pointer to the capabilities.7 man page would be better.
(plus, if you feel they are needed, updates to the man page)

(I'll refrain from detailed review of the contents until this is
discussed.)

-serge
