Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237Ab0CVQkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 12:40:18 -0400
Received: from mail-fx0-f223.google.com ([209.85.220.223]:42664 "EHLO
	mail-fx0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab0CVQkQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 12:40:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=XSn08diyzPxqtcxoH/2nsXah2beTEOZBXb6/7kVe1ZUZhX3R062rN3upLwRmrAgOs8
         b9nite9oXmM23SQ1pNake42nDTZuIu9LQWplXtnRDTg6ugV+cn9onDo5C6dUeeMBKUpo
         BzoU0KoFIMxm/zScX6VeINDj/1SRrDOhLa9h0=
MIME-Version: 1.0
In-Reply-To: <4BA797C9.2030703@redhat.com>
References: <20100321205531.GC30194@elte.hu> <20100322111411.GC3483@elte.hu>
	 <4BA7629B.7020604@redhat.com> <20100322124428.GA12475@elte.hu>
	 <4BA76810.4040609@redhat.com> <20100322143212.GE14201@elte.hu>
	 <4BA7821C.7090900@codemonkey.ws> <20100322155505.GA18796@elte.hu>
	 <4BA796DF.7090005@redhat.com> <4BA797C9.2030703@redhat.com>
Date: Mon, 22 Mar 2010 18:40:15 +0200
X-Google-Sender-Auth: 7707906cd8f6c2b8
Message-ID: <84144f021003220940x25e40624pb0b86f62b79fd707@mail.gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single 
	project
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Fr?d?ric Weisbecker" <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 22, 2010 at 6:16 PM, Avi Kivity <avi@redhat.com> wrote:
>> You simply kept ignoring me when I said that if something can be kept out
>> of the kernel without impacting performance, it should be.  I don't want
>> emergency patches closing some security hole or oops in a kernel symbol
>> server.
>
> Or rather, explained how I am a wicked microkernelist.  The herring were out
> in force today.

Well, if it's not being a "wicked microkernelist" then what is it?
Performance is hardly the only motivation to put things into the
kernel. Think kernel mode-setting and devtmpfs (with the ironic twist
of original devfs being removed from the kernel) here, for example.

                        Pekka
