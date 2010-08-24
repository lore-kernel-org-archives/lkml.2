Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0HXKcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 06:32:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50613 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754188Ab0HXKcH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 06:32:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=hs/khsDnoPj6dR1URwd7t+FOwk4bR7fpwj+YOMddtmhCP0F99e/Y5MWp4brsRQTYkB
         srN4M9VtkfbtbCmx5auO2mWC35XxBHRhV+vvUgnQQKk19+1mXND82GNdxkB4fr55k8u/
         L8WpP5MvSiHDqsl0X3HGSDuJvTirKCGTOsI+M=
MIME-Version: 1.0
In-Reply-To: <1282595927.11194.78.camel@mulgrave.site>
References: <4C69653E.6050808@vlnb.net>
	<1282077040.16098.47.camel@mulgrave.site>
	<4C6C1DC1.8090208@vlnb.net>
	<1282164188.10878.22.camel@mulgrave.site>
	<4C702030.2070306@vlnb.net>
	<1282423128.3015.35.camel@mulgrave.site>
	<AANLkTin9STqUz440fCOEWW=YmedVQtQWU2JLO2wZCt5j@mail.gmail.com>
	<1282582740.11194.17.camel@mulgrave.site>
	<4C72CEC5.4080204@vlnb.net>
	<1282595927.11194.78.camel@mulgrave.site>
Date: Tue, 24 Aug 2010 12:32:05 +0200
X-Google-Sender-Auth: FOdNVQC-DSD9-hTtk6LadrsaAHw
Message-ID: <AANLkTi=vjApRS+hXA8xuNv7NkfLmgCKvQFcMBPWEUeoB@mail.gmail.com>
Subject: Re: [Scst-devel] Fwd: Re: linuxcon 2010...
From: Bart Van Assche <bvanassche@acm.org>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>,
        scst-devel <scst-devel@lists.sourceforge.net>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 10:38 PM, James Bottomley
<James.Bottomley@suse.de> wrote:
> On Mon, 2010-08-23 at 23:40 +0400, Vladislav Bolkhovitin wrote:
>> James Bottomley, on 08/23/2010 08:59 PM wrote:
>> > My basic conclusion was that there's no incredible discriminator between
>> > LIO and STGT (although there are reams written on which performs better
>> > in which circumsances, is useful for clustering, supports ALUA, etc.
>> > each with partisans for the features).
>>
>> Here is a comprehensive features comparison I prepared some time ago:
>> http://scst.sourceforge.net/comparison.html. It's a bit outdated at the
>> moment, but I'm going to make it completely up do date in the next few days.
>
> That's not really going to help ... I don't really want another 500 mail
> thread of partisan yelling about which is better.  I'm happy to concede
> that either could beat the other on a given set of well chosen tests ...
> but knowing that is completely useless to me.  I can also guess, given
> the antipathy, that neither of you would agree on a definitive set of
> comparison tests.
>
> So it comes down to a community test instead: which works better with
> the community.  This is important to me because it's an indication of
> what might ensue once code goes upstream and thus moves outside the
> exclusive province of the project to become a community resource. STGT
> is a community too and so far what you seem to have told me is:
>
>      * STGT users should just migrate to scst_local
>      * STGT doesn't have enough users to bother with
>      * STGT has fundamental design flaws which makes its pass through
>        architecture unusable and its ABI flawed.
>
> I'm sure STGT appreciates the frank assessments, but it doesn't seem to
> merit too many "plays well with others" points.

Although it may not be clear from this thread, we respect the STGT
software and the all work the STGT authors have done to make it a
successful, stable and high performance storage target. The iSCSI-SCST
target driver even contains some of the code that was originally
written by an STGT author (Tomo) for a different project (IET).

A lot has already been discussed in this thread. It is already clear
that integrating LIO instead of SCST would hurt many SCST users. What
is not yet clear is what the consequences would be for LIO users if
SCST would be integrated instead of LIO ? A few months SCST has gained
support for persistent reservations (clustering). The SCSI engine of
SCST is powerful, and the core - target driver interface of SCST is a
rich interface. If there are any user-developed LIO target drivers,
it's probably relatively easy to port these to SCST.

Bart.
