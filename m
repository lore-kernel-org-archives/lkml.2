Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab1A1HIL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 02:08:11 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62513 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482Ab1A1HII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 02:08:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=u4n92WSVJFDUbK7p9COx0R2AwfzdTF92la50llT5ms0ztHqsEg532k0SOg5JwI3DjA
         3NVKHSOKsY74MipYTBc3MG5Ny7CGbQrClzC8u9jkwh1i4ak5LQNnZsRwKW4BHwbz2nRY
         XFYOOwleYIqIi1klLAmi6vpofZj9D1W+25AzQ=
Date: Fri, 28 Jan 2011 08:08:00 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Richard Cochran <richard.cochran@omicron.at>, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org, netdev@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Christoph Lameter <cl@linux.com>, David Miller <davem@davemloft.net>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Mike Frysinger <vapier@gentoo.org>, Paul Mackerras <paulus@samba.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH V10 01/15] time: Introduce timekeeping_inject_offset
Message-ID: <20110128070800.GA3225@riccoc20.at.omicron.at>
References: <cover.1296124770.git.richard.cochran@omicron.at>
 <6aec014551fc1d34924d6a7bcf97769867c15ba9.1296124770.git.richard.cochran@omicron.at>
 <1296154099.2855.162.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296154099.2855.162.camel@work-vm>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 27, 2011 at 10:48:19AM -0800, John Stultz wrote:
> While I appreciate you preserving the path author, and the signoffs are
> right, you really should send the email under your own name.

Guess I've been reading too much spam. It wore off on me.
 
> The proper style is to keep the mail-header From: the same (ie: Richard
> Cochran <richardcochran@gmail.com>), but as the first line of the mail
> body put:
>    From: Author Name <author@lemail.com>

Sorry about this. Arnd already explained this to me, and I did catch
it with V9. This time I forgot.

I would like to get to the bottom of this. Here is what I did:

   1. Saved your patch to disk in mbox format using Mutt.
   2. git am
   3. ... rebase, rebase, rebase, ...
   4. git format-patch [options] 1234..abcd
   5. Edit cover letter
   6. for x in 00*; do mutt -H $x; done

Git format-patch places the "From: John Stultz <john.stultz@linaro.org>"
line with the other mail headers, and so I guess mutt just faithfully
preserves this.

I don't like having to remember to fix this manually. There must be a
better way...

Sorry,
Richard


