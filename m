Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1C1RAB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:00:01 -0400
Received: from smtp-out.google.com ([74.125.121.67]:4194 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753491Ab1C1Q76 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 12:59:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xDQ8lZRzDJNG4ge/TuzjqJjijvM6ALauZH7C6Q7xO3OwC82RCEyTQnD6eG9WN3DiqV
         oyr9at9+ZNLz55JlRntg==
MIME-Version: 1.0
In-Reply-To: <20110328131503.GA7226@redhat.com>
References: <1300756245-12380-1-git-send-email-ctalbott@google.com>
	<20110322150905.GD3757@redhat.com>
	<AANLkTinTiEAFG1F1df380BiDtVFVr=nCsSqhM9__XdQ4@mail.gmail.com>
	<20110322181231.GJ3757@redhat.com>
	<AANLkTi=uB_Wv08xu4SzpjCJ_9isvDPsN=ojTH=wAaDoS@mail.gmail.com>
	<20110323204146.GK13315@redhat.com>
	<AANLkTi=-7gZhEU6qRAt+uGBkb2s2=bkXC81WNScDM6jA@mail.gmail.com>
	<20110325213202.GB21593@redhat.com>
	<AANLkTikTLCdHceaD98zxw90Qb=PuTvfALWELa=Yp6UAC@mail.gmail.com>
	<20110328131503.GA7226@redhat.com>
Date: Mon, 28 Mar 2011 09:59:54 -0700
Message-ID: <AANLkTinwmTjD-Q19U5nCPvoqN2DYGwtLDgeR8h39uWCX@mail.gmail.com>
Subject: Re: [PATCH 0/3] cfq-iosched: Fair cross-group preemption
From: Chad Talbott <ctalbott@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, jaxboe@fusionio.com,
        linux-kernel@vger.kernel.org, mrubin@google.com, teravest@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 6:15 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 25, 2011 at 04:53:13PM -0700, Chad Talbott wrote:
>> Also, we'll soon be working to adopt the hierarchy series, and we'll
>> likely revisit using an RT service tree there.  It's difficult to
>> justify introducing RT service tree before those patches arrive.
>
> So once you move to hierachicy series, will be you using RT class and
> use throttling and abandon this functionality?

I'll certainly investigate using RT class and throttling, but it's too
early to know.  It's a known change in behavior, so it will need
testing (as well as the user-space work to handle the different
interface).

Chad
