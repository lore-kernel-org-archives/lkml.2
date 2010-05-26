Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759183Ab0EZKaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 06:30:21 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:65171 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759154Ab0EZKaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 06:30:18 -0400
MIME-Version: 1.0
In-Reply-To: <1274869262.5882.5222.camel@twins>
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
Date: Wed, 26 May 2010 03:30:17 -0700
Message-ID: <AANLkTilp1zWqvmUzGjEX3x9OBsdXdvNEG-znTjVvoM-b@mail.gmail.com>
Subject: Re: [PATCH 1/8] PM: Opportunistic suspend support.
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Florian Mickler <florian@mickler.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <ak@linux.intel.com>,
       Cornelia Huck <cornelia.huck@de.ibm.com>, Tejun Heo <tj@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Nigel Cunningham <nigel@tuxonice.net>, Ming Lei <tom.leiming@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-doc@vger.kernel.org,
       Matthew Garrett <mjg59@srcf.ucam.org>, Greg KH <gregkh@suse.de>,
       tytso@mit.edu, James Bottomley <James.Bottomley@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/5/26 Peter Zijlstra <peterz@infradead.org>:
> On Wed, 2010-05-26 at 03:17 -0700, Arve Hjønnevåg wrote:
>> > With a single suspend manager process that manages the suspend state you
>> > can achieve the same goal.
>> >
>>
>> Yes we don't need the /dev interface, but it is useful. Without it any
>> program that needs to block suspend has to make a blocking ipc call
>> into the suspend manager process. Android already does this for java
>> code, but system processes written in C block suspend directly with
>> the kernel since they cannot use the java APIs.
>
> So provide a C interface to it as well?
>

We could, but the result would be that any program that needs to block
suspend has to be android specific.

> Surely you can have the java thing have a unix socket or something a C
> app can talk to. That shouldn't be hard at all.
>
> Or make the suspend manager a C proglet and provide a JNI interface, or
> whatever.
>


-- 
Arve Hjønnevåg
