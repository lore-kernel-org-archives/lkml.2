Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866Ab1FBAGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 20:06:20 -0400
Received: from mail-px0-f179.google.com ([209.85.212.179]:57439 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab1FBAGT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 20:06:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qoq2/X04vLJuxBtR7Vbg+c7m8jbE3E/zdU2vH3Hizl7+nCnfRH/KT4wokmxfvDp/yp
         4PJMlSJr+AmISP09HRrmRjk2dUF/pJ6Q58nrwWv4aDr/WAUtq0w5R21OvSFQTSnQ2W1w
         TjUd6ki7Tkb6lZDVRDwd8GjxFvjUE4Sag+U9s=
MIME-Version: 1.0
In-Reply-To: <20110601225723.GA18471@suse.de>
References: <BANLkTi=6-sGL9QJbyK34kCPbaPVOREE1QA@mail.gmail.com>
	<20110601211506.GA16121@suse.de>
	<BANLkTi=MF2ApN4yRvFOr2sM3PbrnRGPtng@mail.gmail.com>
	<20110601225723.GA18471@suse.de>
Date: Wed, 1 Jun 2011 17:06:18 -0700
Message-ID: <BANLkTinxbqs1gHMSv5YPF0fCK1AOiCXTwg@mail.gmail.com>
Subject: Re: Long-term stable versions in linux-2.6-stable.git?
From: Bryan Hundven <bryanhundven@gmail.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 1, 2011 at 3:57 PM, Greg KH <gregkh@suse.de> wrote:
> On Wed, Jun 01, 2011 at 03:33:21PM -0700, Bryan Hundven wrote:
>> On Wed, Jun 1, 2011 at 2:15 PM, Greg KH <gregkh@suse.de> wrote:
>> > On Wed, Jun 01, 2011 at 10:38:35AM -0700, Bryan Hundven wrote:
>> >> Hello,
>> >>
>> >> I was wondering if there are plans to include the long-term stable
>> >> versions in the /pub/scm/linux/kernel/git/stable/linux-2.6-stable.git
>> >> repository?
>> >>
>> >> I'm not subscribed to lkml, please cc on response.
>> >
>> > It's been discussed numerous times in the past, the thing is, I don't
>> > control the script that does this so I have no control over it, sorry.
>>
>> Ok. The reason I ask is that it is painful to merge changes from
>> 2.6.35.13 back to 2.6.35.9, then forward to >2.6.36, although I guess
>> I will have to live with it.
>
> Why would you have to do that?  Why can't you just create the tree
> yourself by pulling from the different longterm branches?

That works too. Thank you!

>> If you don't mind me asking; who controls the script that does this?
>
> I really don't know, sorry.
>
