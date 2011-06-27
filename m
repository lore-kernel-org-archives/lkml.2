Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904Ab1F0D3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 23:29:19 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:32815 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab1F0D1Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 23:27:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type:content-transfer-encoding;
        b=Y2tS1JY5UgPTajFkR1thurb4nKVAOBy/qXgY13XpcBSiJT6wFHQwBLkF6xVAYWxb6Y
         9WQxt8RrVzgEn1OsGJ9IypzEKgoPvzcFNKdwP5aVMq/4no+t1ctV3uYokxKO21HO3fwB
         riOKQLR2+plTHqgI8j7urwOcTnKdNkWc+cTts=
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <43010.1308838745@turing-police.cc.vt.edu>
References: <1308795351.15248.2.camel@phoenix> <43010.1308838745@turing-police.cc.vt.edu>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 27 Jun 2011 11:26:55 +0800
Message-ID: <BANLkTik7kNzrCs9yv2DxTZykWGLw_QDDnw@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: Add Makefile and Kconfig Entries for tps65911 comparator
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/6/23  <Valdis.Kletnieks@vt.edu>:
> On Thu, 23 Jun 2011 10:15:51 +0800, Axel Lin said:
>> Base on Mark's comment [1], I make the Kconfig entry invisible to users.
>
>> +config TPS65911_COMPARATOR
>> +     tristate
>> +
>
> This can't possibly be right by itself- how would it ever get enabled, without
> a SELECT pointing at it or a user selecting it?
>
> Is there a follow-on patch that adds a user?
>

I was thinking the driver that adds "tps65911-comparator" device should
select CONFIG_TPS65911_COMPARATOR symbol.

Or maybe it is ok just make config TPS65911_COMPARATOR visible to users and
make it depend on MFD_TPS65910.

Comments?

Regards,
Axel
