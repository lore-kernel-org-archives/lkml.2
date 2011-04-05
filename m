Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab1DES5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 14:57:42 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6713 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939Ab1DES5i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 14:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=NQAwkpWVDsQ3ff8HbzcSZk1G+lkmcKstNhJAABNkF4WFxhT9L3duTCrtjPDvO4RjAS
         d2mHfPIlg41IND/uoIhg==
MIME-Version: 1.0
In-Reply-To: <20110405173028.GC20622@kroah.com>
References: <4D9B4E3A.4090601@redhat.com> <20110405173028.GC20622@kroah.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 5 Apr 2011 11:57:13 -0700
Message-ID: <BANLkTi=pRVc+qc6DOHCdW3v7GcMu9U9bjQ@mail.gmail.com>
Subject: Re: /sys/firmware/dmi name change?
To: Greg KH <greg@kroah.com>
Cc: Prarit Bhargava <prarit@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Don Zickus <dzickus@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 10:30 AM, Greg KH <greg@kroah.com> wrote:
> On Tue, Apr 05, 2011 at 01:15:38PM -0400, Prarit Bhargava wrote:
>> commit 948af1f0bbc8526448e8cbe3f8d3bf211bdf5181 (and follow on commits)
>> introduced a new firmware directory called /sys/firmware/dmi which
>> provides broken out SMBIOS entries for userspace.
>>
>> In a previous discussion I've mentioned that it would be a good idea for
>> us to move away from using 'dmi' towards using 'smbios' and centralizing
>> the SMBIOS code that is scattered throughout the kernel.  One of my
>> changes was to export the SMBIOS information in a similar way that Mike
>> did in drivers/firmware/dmi-sysfs.c.
>>
>> Since this API is new for 2.6.39, can we change the name of the
>> directory to /sys/firmware/smbios?  Otherwise in 2.6.40, when further
>> changes are introduced to use SMBIOS in the kernel we will have to
>> change something that has been stable for one release.
>>
>> Mike?  Greg?  Alan?  What do you think?  IIUC, the interface isn't yet
>> "stable" so it should be changed now, correct?
>
> Fine with me if Mike's ok with it as well.  If so, someone send me a
> patch quick!

Sounds good to me.

>
> thanks,
>
> greg k-h
>
