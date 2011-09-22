Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751384Ab1IVPog (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 11:44:36 -0400
Received: from smtp-out.google.com ([216.239.44.51]:63409 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab1IVPoe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 11:44:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=HDMEaO5qBbBEdnjy4t97KpAA5IFintnKilRIEOe5lNIPprGrlftAyiVBldN16sziR
	umZlW7rf7K/QcOVBc/6jw==
MIME-Version: 1.0
In-Reply-To: <20110922095803.GA4530@shutemov.name>
References: <1316393805-3005-1-git-send-email-glommer@parallels.com>
 <1316393805-3005-7-git-send-email-glommer@parallels.com> <CAHH2K0Yuji2_2pMdzEaMvRx0KE7OOaoEGT+OK4gJgTcOPKuT9g@mail.gmail.com>
 <20110922095803.GA4530@shutemov.name>
From: Greg Thelen <gthelen@google.com>
Date: Thu, 22 Sep 2011 08:44:11 -0700
Message-ID: <CAHH2K0ZMq_jCGr3m3PZDtmDwHUXnnL-fuQDt-A-SdUKgeK6P6g@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] tcp buffer limitation: per-cgroup limit
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        paul@paulmenage.org, lizf@cn.fujitsu.com,
        kamezawa.hiroyu@jp.fujitsu.com, ebiederm@xmission.com,
        davem@davemloft.net, netdev@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 2:58 AM, Kirill A. Shutemov
<kirill@shutemov.name> wrote:
> On Wed, Sep 21, 2011 at 11:01:46PM -0700, Greg Thelen wrote:
>> On Sun, Sep 18, 2011 at 5:56 PM, Glauber Costa <glommer@parallels.com> wrote:
>> > +static inline bool mem_cgroup_is_root(struct mem_cgroup *mem)
>> > +{
>> > +       return (mem == root_mem_cgroup);
>> > +}
>> > +
>>
>> Why are you adding a copy of mem_cgroup_is_root().  I see one already
>> in v3.0.  Was it deleted in a previous patch?
>
> mem_cgroup_is_root() moved up in the file.

Got it.  Thanks.
