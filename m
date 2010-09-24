Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab0IXFcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 01:32:22 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48151 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356Ab0IXFcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 01:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=okqNBrCDI44KHB+ngSEsRPu3YMnP3ytImmTs1VhTzR7D4EpQll9N0LkGzNLYtH1i7q
         kWAU8Kw8pYiXXC4b4ialqsLTQynOZN+Cn2m0GrNeaSDBEDLNpskAzEQayrB2oQPPOHkK
         R5FfWfcD/0ClC31lzLicnAA/uCkC9NvodsFFk=
Date: Fri, 24 Sep 2010 13:36:48 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Geoffrey Said <geoffrey@2x.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: Long maintenance kernel versions.
Message-ID: <20100924053648.GA5453@cr0.nay.redhat.com>
References: <AANLkTinGJmAzdd=HOKZYSh69F6T9HMznOKW5BS90=Q-4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinGJmAzdd=HOKZYSh69F6T9HMznOKW5BS90=Q-4@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 07:10:09AM +0200, Geoffrey Said wrote:
>To whom it may concern.
>
>I would like to put forward the following questions.  Hope that I am
>not making a fool of myself!
>
>How is the procedure by which a certain kernel version is declared as
>a long maintenance version?


This mainly depends on how many major Linux distributions rely on
that version of kernel, AFAIK.

>Is the version decided before or after the release of the stable kernel?

After.

>And where can I check for planned long term maintenance versions?
>

http://en.wikipedia.org/wiki/Linux_kernel

