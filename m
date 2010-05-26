Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626Ab0EZLQX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 07:16:23 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:42397 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757228Ab0EZLQV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 07:16:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=af1nHH3d0NBYbDDLyP4it5WUySvtpe1h4R1OtuWOsLuziok8ieiFAeTNwSww6WvMBv
         z0iqMakFP4N8O2QH5Vv8ieHKRhSEv3NcMoN78iLnwSXQtikzYgpbTw/KXsz5ANLMHK5Z
         Z9DAlazkI+PakEcbJYMzjzBMUPY45fhJvTu74=
MIME-Version: 1.0
In-Reply-To: <AANLkTilp1zWqvmUzGjEX3x9OBsdXdvNEG-znTjVvoM-b@mail.gmail.com>
References: <Pine.LNX.4.44L0.1005251647530.1634-100000@iolanthe.rowland.org>
	<201005252344.37639.rjw@sisk.pl>
	<AANLkTimL5rU5lALezEZVCwdcZL85tVahhsTibdpq9s-Y@mail.gmail.com>
	<1274863342.5882.4850.camel@twins>
	<20100526112303.3fef15a4@schatten.dmk.lab>
	<1274866402.5882.5051.camel@twins>
	<AANLkTil9ZtMFxTfE6ITiFNOl4S1k3Lvdp5BPgGX7LJhw@mail.gmail.com>
	<1274868384.5882.5169.camel@twins>
	<AANLkTimHGpRAZklIwXu6wEbA3coKXJvCVLxj2twerkCw@mail.gmail.com>
	<1274869262.5882.5222.camel@twins>
	<AANLkTilp1zWqvmUzGjEX3x9OBsdXdvNEG-znTjVvoM-b@mail.gmail.com>
Date: Wed, 26 May 2010 13:16:18 +0200
Message-ID: <AANLkTimxXcupV0KX1nQIPbuRzZYXZwCebDVahxR-kWkJ@mail.gmail.com>
Subject: Re: [linux-pm] [PATCH 1/8] PM: Opportunistic suspend support.
From: Vitaly Wool <vitalywool@gmail.com>
To: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-doc@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andi Kleen <ak@linux.intel.com>, Florian Mickler <florian@mickler.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Len Brown <len.brown@intel.com>, tytso@mit.edu,
       Greg KH <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Arve Hjønnevåg <arve@android.com>:
> 2010/5/26 Peter Zijlstra <peterz@infradead.org>:
>> On Wed, 2010-05-26 at 03:17 -0700, Arve Hjønnevåg wrote:
>>> > With a single suspend manager process that manages the suspend state you
>>> > can achieve the same goal.
>>> >
>>>
>>> Yes we don't need the /dev interface, but it is useful. Without it any
>>> program that needs to block suspend has to make a blocking ipc call
>>> into the suspend manager process. Android already does this for java
>>> code, but system processes written in C block suspend directly with
>>> the kernel since they cannot use the java APIs.
>>
>> So provide a C interface to it as well?
>>
>
> We could, but the result would be that any program that needs to block
> suspend has to be android specific.

Just a suspicion, but... The things you're saying don't make sense to
me other than if you're fighting with GPL in userspace here.

~Vitaly
