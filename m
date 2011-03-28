Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1C1STF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:19:05 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55260 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1C1STD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:19:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=v0pWAr9A+eZmysyxs2epuyG16EtSfkJYfBQ7PiMXIMmvy+d6GyS0GhrBg5pxcdZpzr
         6b7PMviOR5xyyl64X2BqJt0apj1cUZyTZVOVp0vIPv+CSC9iiYRBILP9NLbbQvSA8PLD
         N2EeuVujrXDgriVoQrSw1nCuYfCgu7GRN0f+c=
Date: Mon, 28 Mar 2011 21:18:56 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        torvalds@linux-foundation.org, srostedt@redhat.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/urgent] WARN_ON_SMP(): Add comment to explain ({0;})
Message-ID: <20110328181855.GA6146@p183.telecom.by>
References: <tip-ccd0d44fad38dc1bb4b26dcc7a30e9f2c3b36870@git.kernel.org>
 <4D90A08D.707@zytor.com>
 <AANLkTinh6nraZND1mQJ4ofPbABOtJNEnGYYEkqs92RQM@mail.gmail.com>
 <4D90A1FE.4000405@zytor.com>
 <1301324940.14261.232.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1301324940.14261.232.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 11:09:00AM -0400, Steven Rostedt wrote:
> Geeze, I never expected such a fuss over a simple change ;)

And it's still broken ;-)

	[spoiler space]































WARN_ON_SMP(x) should expand to x, not 0.
