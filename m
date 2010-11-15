Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab0KORuQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 12:50:16 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60641 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756163Ab0KORuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 12:50:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=QjXWVtNoVBVLVY+H85EBGvlJHY6qn4rInaSn2mApOcQ1g6FaeGzTfUTYQYvs1NP7yl
         T/M8f9UIB0YkXpFrZG0ctnah3P5cYBRKUWyR7qXAHXJNQqe5KQs4Vk0p/+iMBMoy1dQO
         QWRXkz92YKCB9wm0EXv5n4khSFl0L+Xc8e8UQ=
MIME-Version: 1.0
In-Reply-To: <4CE16B8E.1000300@panasas.com>
References: <20101109002829.GA22633@kroah.com> <4CD9A9B8.70708@vlnb.net>
 <4CDA6CD4.3010308@panasas.com> <4CDAFE6E.7050200@vlnb.net>
 <4CDBBE80.40908@panasas.com> <4CDC56F9.9040601@vlnb.net> <20101112012315.GE17097@core.coreip.homeip.net>
 <4CDEC8D2.8080101@vlnb.net> <20101113235938.GA1827@kroah.com>
 <4CE1017E.4090409@panasas.com> <20101115161620.GB5981@kroah.com> <4CE16B8E.1000300@panasas.com>
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 15 Nov 2010 18:49:52 +0100
X-Google-Sender-Auth: vbco5tsrxBqohh2M_r5cc-BmPQs
Message-ID: <AANLkTikPVXGJ5-5YDk1uqfqrqxGLpSiSdaX3h7qxo-ie@mail.gmail.com>
Subject: Re: [PATCH 8/19]: SCST SYSFS interface implementation
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Greg KH <greg@kroah.com>, Vladislav Bolkhovitin <vst@vlnb.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>,
        James Smart <James.Smart@emulex.com>, Joe Eykholt <jeykholt@cisco.com>,
        Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>,
        Hannes Reinecke <hare@suse.de>,
        Richard Sharpe <realrichardsharpe@gmail.com>,
        Daniel Henrique Debonzi <debonzi@linux.vnet.ibm.com>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 15, 2010 at 6:19 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> [ ... ]
> Perhaps consider a new alternative like the device tree as Greg suggested
> or maybe finally accept the harsh realities of ConfigFS.

I think that Vlad has already explained several times why ConfigFS is
not suited for the needs of a storage target: a storage target must
not only be able to accept configuration information from userspace
but must also be able to create new directories and file nodes itself.
See e.g. this message from October 6:
http://kerneltrap.org/mailarchive/linux-kernel/2010/10/6/4628664.

Bart.
