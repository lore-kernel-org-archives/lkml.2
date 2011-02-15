Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab1BOSoy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 13:44:54 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:49415 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754998Ab1BOSow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 13:44:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DlASohRW0tL1qcfetjxNk9Y6b0v67L4kc6M4tde9Hw5rcAlH93hB/YMFNRYQ3P/2n4
         W1J8yWd4AijMd74kQ/xcAskDqpWZs50tcgkD1NR9uERADHJMWNodUqz4pdm64VQwqJFp
         y16oa24a4nMQ/Foif207aA1TymARs9QwxilYo=
Date: Tue, 15 Feb 2011 10:44:42 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: Greg KH <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
Message-ID: <20110215184441.GA19688@core.coreip.homeip.net>
References: <1297447183-21807-1-git-send-email-kys@microsoft.com>
 <4D5A4565.5030501@gmail.com>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085CF8@TK5EX14MBXC104.redmond.corp.microsoft.com>
 <20110215140305.GA10301@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085D7F@TK5EX14MBXC104.redmond.corp.microsoft.com>
 <20110215162933.GA30626@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085DE6@TK5EX14MBXC104.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB42D5CCD7B5934EB1827DB5ED9B850E07085DE6@TK5EX14MBXC104.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 05:52:46PM +0000, KY Srinivasan wrote:
> 
> If I understand you correctly, you would be prefer to have unbounded waiting with comments 
> justifying why we cannot have timeouts. I will roll out a patch once the tree stabilizes.
> 

Just make sure to add a comment explaining why the wait is unbounded.

-- 
Dmitry
